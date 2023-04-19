package vault

import (
	"context"
	"encoding/json"
	"fmt"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"sync"

	"github.com/da-moon/go-primitives"
	"github.com/palantir/stacktrace"
)

type Recursive struct {
	sync.RWMutex
	dirCounter   int
	entryCounter int
	backend      *Backend
	entries      []string
	tree         string
}

func (b *Backend) Recursive() *Recursive {
	return &Recursive{
		dirCounter:   0,
		entryCounter: 0,
		backend:      b,
		entries:      make([]string, 0),
		tree:         "",
	}
}
func (r *Recursive) index(path string) {
	r.Lock()
	defer r.Unlock()
	if strings.HasSuffix(path, "/") {
		r.dirCounter += 1
	} else {
		r.entryCounter += 1
		r.entries = append(r.entries, path)
	}
}

func (r *Recursive) dirnamesFrom(base string) ([]string, error) {
	r.Lock()
	defer r.Unlock()

	backend := r.backend
	if len(base) == 0 {
		base = "/"
	}
	if !strings.HasSuffix(base, "/") {
		return nil, nil
	}

	keyObjects, err := backend.List(context.Background(), base)
	if err != nil {
		err = stacktrace.Propagate(err, "could not list keys")
		return nil, err
	}
	// dirnamesFrom

	keys := make([]string, 0)
	for _, v := range keyObjects {
		elem := fmt.Sprint(v)
		keys = append(keys, elem)
	}
	sort.Strings(keys)
	return keys, nil
}

func (r *Recursive) recurse(base string, prefix string) error {
	names, err := r.dirnamesFrom(base)
	if err != nil {
		return err
	}
	for index, name := range names {
		subpath := base + name
		r.index(subpath)
		if index == len(names)-1 {
			r.Lock()
			row := fmt.Sprintf("%s%s", prefix+"└──", strings.TrimSuffix(name, "/"))
			r.tree = fmt.Sprintf("%s%s\n", r.tree, row)
			r.Unlock()
			r.recurse(subpath, prefix+"    ")
		} else {
			r.Lock()
			row := fmt.Sprintf("%s%s", prefix+"├──", strings.TrimSuffix(name, "/"))
			r.tree = fmt.Sprintf("%s%s\n", r.tree, row)
			r.Unlock()
			r.recurse(subpath, prefix+"│   ")
		}
	}
	return nil
}
func (r *Recursive) Tree(prefix string) (string, error) {
	base := primitives.PathJoin(prefix, "/")
	err := r.recurse(base, "")
	if err != nil {
		return "", err
	}
	return r.tree, nil
}
func (r *Recursive) List(prefix string) ([]string, error) {
	base := primitives.PathJoin(prefix, "/")
	err := r.recurse(base, "")
	if err != nil {
		return nil, err
	}
	for k, v := range r.entries {
		r.entries[k] = strings.TrimLeft(v, "/")
	}
	return r.entries, nil
}
func (r *Recursive) Read(prefix string) ([]Entry, error) {
	base := primitives.PathJoin(prefix, "/")
	err := r.recurse(base, "")
	if err != nil {
		return nil, err
	}
	result := make([]Entry, 0)
	for _, k := range r.entries {
		entry, err := r.backend.Get(context.Background(), k)
		if err != nil {
			r.backend.log.Error("could not read entry recursively: %v", err)
			continue
		}
		if entry != nil {
			switch x := entry.(type) {
			case []*Entry:
				for _, v := range x {
					v.Key = strings.TrimLeft(v.Key, "/")
					result = append(result, *v)
				}
			case *Entry:
				x.Key = strings.TrimLeft(x.Key, "/")
				result = append(result, *x)
			}

		}
	}
	return result, nil
}
func (r *Recursive) Delete(prefix string) {
	base := primitives.PathJoin(prefix, "/")
	r.recurse(base, "")
	for _, k := range r.entries {
		err := r.backend.Delete(context.Background(), k)
		if err != nil {
			r.backend.log.Error("could not delete entry recursively: %v", err)
			continue
		}
	}
}

func (r *Recursive) MountSourceDetails() (int, error) {

	mount, err := r.backend.Client.Sys().ListMounts()

	if err != nil {
		return 0, err
	}

	var version int

	for k, v := range mount {
		if strings.Contains(k, r.backend.Mount) {
			// r.backend.log.Trace(k)
			// r.backend.log.Trace("%v\n", v)
			if val, ok := v.Options["version"]; ok {
				if val == "2" {
					version = 2
				} else if val == "1" {
					version = 1
				}
			} else {
				version = 1
			}
		}
	}

	r.backend.log.Trace(r.backend.Mount)
	r.backend.log.Trace(fmt.Sprint(version))

	return version, nil
}

func (r *Recursive) MountSourceDetailsUI() (int, error) {

	var apiPath string = "sys/internal/ui/mounts"
	mount, err := r.backend.Client.Logical().Read(apiPath)
	if err != nil {
		return 0, err
	}
	r.backend.log.Trace("MountSourceDetailsUI: contents of %s call: %v", apiPath, mount.Data)
	r.backend.log.Trace("MountSourceDetailsUI: %v", mount.Data["secret"])

	/* OLD
	var secMounts map[string]interface{} = mount.Data["secret"].(map[string]interface{})
	r.backend.log.Trace("MountSourceDetailsUI: %v", secMounts[fmt.Sprintf("%s/", r.backend.Mount)])
	var mountDetails map[string]interface{} = secMounts[fmt.Sprintf("%s/", r.backend.Mount)].(map[string]interface{})
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountDetails["options"])
	var mountOptions map[string]interface{} = mountDetails["options"].(map[string]interface{})
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountOptions["version"])
	var mountVersion string = mountOptions["version"].(string)
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountVersion)
	*/
	secMounts, ok := mount.Data["secret"].(map[string]interface{})
	if !ok {
		r.backend.log.Trace("MountSourceDetailsUI: Assertion error for secret key")
		return 0, fmt.Errorf("assertion error for 'secret' key")
	}
	r.backend.log.Trace("MountSourceDetailsUI: %v", secMounts[fmt.Sprintf("%s/", r.backend.Mount)])
	mountDetails, ok := secMounts[fmt.Sprintf("%s/", r.backend.Mount)].(map[string]interface{})
	if !ok {
		r.backend.log.Trace("MountSourceDetailsUI: Assertion error for r.backend.Mount key with value %s", r.backend.Mount)
		return 0, fmt.Errorf("assertion error for 'r.backend.Mount' key")
	}
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountDetails["options"])
	mountOptions, ok := mountDetails["options"].(map[string]interface{})
	if !ok {
		if mountDetails["options"] == nil {
			r.backend.log.Trace("MountSourceDetailsUI: Nil value for options key, default to KV v1")
			return 1, nil
		} else {
			r.backend.log.Trace("MountSourceDetailsUI: Assertion error for options key")
			return 0, fmt.Errorf("assertion error for 'options' key")
		}
	}
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountOptions["version"])
	mountVersion, ok := mountOptions["version"].(string)
	if !ok {
		r.backend.log.Trace("MountSourceDetailsUI: Assertion error for version key")
		return 0, fmt.Errorf("assertion error for 'version' key")
	}
	r.backend.log.Trace("MountSourceDetailsUI: %v", mountVersion)

	var version int

	//for k, v := range secMounts {
	//if strings.Contains(k, r.backend.Mount) {
	// r.backend.log.Trace(k)
	// r.backend.log.Trace("%v\n", v)
	if val := mountVersion; val != "" {
		if val == "2" {
			version = 2
		} else if val == "1" {
			version = 1
		}
	} else {
		version = 1
	}
	//}
	//}

	r.backend.log.Trace(r.backend.Mount)
	r.backend.log.Trace(fmt.Sprint(version))

	return version, nil
}

// method MountDesinationExist checks that the destination mount exists and
// returns the version number of the mount
func (r *Recursive) MountDesinationExist() (int, error) {

	mount, err := r.backend.Client.Sys().ListMounts()

	if err != nil {
		return 0, err
	}

	var version int
	exist := false

	for k, v := range mount {
		if strings.Contains(k, r.backend.Mount) {
			// r.backend.log.Trace(k)
			// r.backend.log.Trace("%v\n", v)
			if val, ok := v.Options["version"]; ok {
				ver, err := strconv.ParseInt(val, 10, 64)
				if err != nil {
					return 0, err
				}
				version = int(ver)
			} else {
				version = 1
			}
			exist = true
			r.backend.log.Trace("destination mount point already exist")
			break
		}
	}

	if !exist {
		r.backend.log.Trace("destination mount point does not exist")
		return 0, fmt.Errorf("destination mount point does not exist")
	}

	r.backend.log.Trace(r.backend.Mount)
	r.backend.log.Trace(fmt.Sprint(version))

	return version, nil
}

// func (r *Recursive) Move(source, destination, ns, srcVersion string) error {
// 	result := make([]Entry, 0)
// 	move := make(map[string]Entry)
// 	entry, err := r.backend.Get(context.Background(), source)
// 	if err == nil && entry != nil && entry.Value != nil {
// 		entry.Key = strings.TrimLeft(entry.Key, "/")
// 		dest := ""
// 		if destination != "/" {
// 			dest = destination
// 		}
// 		if strings.HasSuffix(destination, "/") {
// 			dest = primitives.PathJoin(dest, filepath.Base(source))
// 		}
// 		move[dest] = *entry
// 	} else {
// 		base := primitives.PathJoin(source, "/")
// 		err = r.recurse(base, "")
// 		if err != nil {
// 			return err
// 		}
// 		for _, k := range r.entries {
// 			entry, err := r.backend.Get(context.Background(), k)
// 			if err != nil {
// 				r.backend.log.Error("could read entry recursively")
// 				continue
// 			}
// 			if entry != nil {
// 				entry.Key = strings.TrimLeft(entry.Key, "/")
// 				result = append(result, *entry)
// 				dest := primitives.PathJoin(destination, strings.TrimPrefix(entry.Key, source))
// 				move[dest] = *entry

// 			}
// 		}
// 	}

// 	for dest, entry := range move {
// 		r.backend.log.Debug("%s=>%s", entry.Key, dest)
// 		r.backend.log.Debug("%s=>%v", entry.Key, entry.Value)
// 		r.Lock()
// 		err = r.backend.Put(context.Background(), &Entry{
// 			Key:   dest,
// 			Value: entry.Value,
// 		}, ns, srcVersion)
// 		if err != nil {
// 			err = stacktrace.Propagate(err, "could not complete move operation")
// 			return err
// 		}
// 		//r.backend.Delete(context.Background(), entry.Key)
// 		r.Unlock()
// 	}
// 	return nil
// }

func (r *Recursive) Fetch(source, destination string) ([]map[string]Entry, error) {
	move := make([]map[string]Entry, 0)
	r.backend.log.Debug("Fetch method: Checkpoint 1")
	entry, err := r.backend.Get(context.Background(), source)
	r.backend.log.Debug("Fetch method: Checkpoint 2")

	r.backend.log.Trace("Fetch: Entry: %v, Error: %v", entry, err)
	r.backend.log.Debug("Fetch method: Checkpoint 3")

	switch x := entry.(type) {
	case []*Entry:
		r.backend.log.Debug("Fetch method: Checkpoint 4")
		if err == nil && entry != nil && len(x) != 0 {

			fmt.Println("Fetch: []Entry, len:", len(x))

			for i, v := range x {
				dest := ""

				if destination != "/" {
					dest = destination
				}
				if strings.HasSuffix(destination, "/") {
					dest = primitives.PathJoin(dest, filepath.Base(source))
				}

				jsonString, err := json.Marshal(v)
				if err != nil {
					return nil, err
				}

				r.backend.log.Trace("Fetch: []Entry source: %s, %s", source, jsonString)

				m := make(map[string]interface{})
				err = json.Unmarshal(v.Value, &m)
				if err != nil {
					fmt.Println(err.Error())
				}
				r.backend.log.Trace("Fetch: []Entry metatdata: %v", m["metadata"].(map[string]interface{})["data"].(map[string]interface{})["versions"].(map[string]interface{})[fmt.Sprintf("%d", i)])

				move = append(move, map[string]Entry{dest: *v})
				r.backend.log.Trace("Fetch: Entry added: %s", dest+fmt.Sprintf("-%d", i+1))
			}
		}
	case *Entry:
		r.backend.log.Debug("Fetch method: Checkpoint 5")
		if err == nil && x != nil && x.Value != nil {
			r.backend.log.Debug("Fetch method: Checkpoint 6")
			dest := ""

			if destination != "/" {
				dest = destination
			}
			if strings.HasSuffix(destination, "/") {
				dest = primitives.PathJoin(dest, filepath.Base(source))
			}

			jsonString, err := json.Marshal(x)
			if err != nil {
				return nil, err
			}

			r.backend.log.Debug("Fetch method: Checkpoint 7")
			r.backend.log.Trace("Fetch: Entry source: %s, %s", source, jsonString)

			m := make(map[string]interface{})
			err = json.Unmarshal(x.Value, &m)
			if err != nil {
				fmt.Println(err.Error())
			}
			r.backend.log.Debug("Fetch method: Checkpoint 11")
			//fmt.Println(m)
			if m["metadata"] != nil && m["data"] != nil {
				r.backend.log.Trace(
					"Fetch: Entry metatdata: %v",
					m["metadata"].(map[string]interface{})["data"].(map[string]interface{})["versions"].(map[string]interface{})["1"],
				)
			}

			r.backend.log.Debug("Fetch method: Checkpoint 12")
			move = append(move, map[string]Entry{dest: *x})
			r.backend.log.Debug("Fetch method: Checkpoint 13")
			r.backend.log.Trace("Fetch: Entry added: %s", dest+"-0")

		} else {
			r.backend.log.Debug("Fetch method: Checkpoint 8")
			base := primitives.PathJoin(source, "/")
			err = r.recurse(base, "")

			if err != nil {
				return nil, err
			}

			r.backend.log.Debug("Fetch method: Checkpoint 9")
			r.backend.log.Trace("Fetch: base: %s", base)
			r.backend.log.Trace("Fetch: entries: %v", r.entries)
			for _, k := range r.entries {
				entry, err := r.backend.Get(context.Background(), k)

				if err != nil {
					r.backend.log.Error("could not read entry recursively")
					continue
				}
				if entry != nil {

					r.backend.log.Debug("Fetch method: Checkpoint 10")
					switch x := entry.(type) {
					case []*Entry:
						for i, v := range x {
							jsonString, err := json.Marshal(v)
							if err != nil {
								return nil, err
							}

							m := make(map[string]interface{})
							err = json.Unmarshal(v.Value, &m)
							if err != nil {
								fmt.Println(err.Error())
							}
							// r.backend.log.Trace("Fetch: []Entry range metatdata: %v", m["metadata"].(map[string]interface{})["data"].(map[string]interface{})["versions"].(map[string]interface{})[fmt.Sprintf("%d", i)])
							r.backend.log.Trace("Fetch: entries []Entry range: %s, %s", k, jsonString)
							dest := primitives.PathJoin(destination, strings.TrimPrefix(v.Key, source))
							move = append(move, map[string]Entry{dest: *v})
							r.backend.log.Trace("Fetch: Entry added: %s", dest+fmt.Sprintf("-%d", i+1))
						}
					case *Entry:
						jsonString, err := json.Marshal(x)
						if err != nil {
							return nil, err
						}

						r.backend.log.Trace("Fetch: entries Entry range: %s, %s", k, jsonString)
						dest := primitives.PathJoin(destination, strings.TrimPrefix(x.Key, source))

						m := make(map[string]interface{})
						//var m interface{}
						err = json.Unmarshal(x.Value, &m)
						if err != nil {
							r.backend.log.Debug(err.Error())
							return nil, err
						}
						// PrettyPrint(*x)
						// PrettyPrint(m)
						if m["metadata"] != nil {

							converted, ok := m["metadata"].(map[string]interface{})["data"].(map[string]interface{})["versions"].(map[string]interface{})["1"]
							if ok {
								r.backend.log.Trace("Fetch: []Entry range metatdata: %v", converted)
							}
						} else {
							r.backend.log.Debug("Fetch method: Checkpoint 16")
							// PrettyPrint(m["data"])

						}
						move = append(move, map[string]Entry{dest: *x})
						r.backend.log.Trace("Fetch: Entry added: %s", dest+"-0")
					}

				}
			}
		}
	}
	return move, nil
}

func PrettyPrint(v interface{}) (err error) {
	b, err := json.MarshalIndent(v, "", "  ")
	if err == nil {
		fmt.Println(string(b))
	}
	return
}

func (r *Recursive) Push(move []map[string]Entry, srcVersion string) error {

	r.backend.log.Debug("Fetch method: Checkpoint 20")
	for _, v := range move {
		r.backend.log.Debug("Fetch method: Checkpoint 21")
		//PrettyPrint(v)
		for dest, entry := range v {
			r.backend.log.Debug("Push: KEY: %s", entry.Key)
			r.backend.log.Debug("Push: DEST KEY: %s", dest)
			r.Lock()
			err := r.backend.Put(context.Background(), &Entry{
				Key:   dest,
				Value: entry.Value,
			}, r.backend.namespace, srcVersion)
			if err != nil {
				err = stacktrace.Propagate(err, "could not complete copy operation")
				return err
			}
			r.Unlock()
		}
	}

	return nil
}
