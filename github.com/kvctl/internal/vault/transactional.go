package vault

import (
	"context"
	"strings"

	stacktrace "github.com/palantir/stacktrace"
)

// Transaction -
func (b *Backend) Transaction(ctx context.Context, txns []*TxnEntry) error {
	b.semaphore.Wait()
	defer b.semaphore.Signal()

	b.Lock()
	defer b.Unlock()

	return b.GenericTransactionHandler(ctx, txns)
}

// TxnEntry is an operation that takes atomically as part of
// a transactional update. Only supported by Transactional backends.
type TxnEntry struct {
	Operation Operation
	Entry     *Entry
}

// type Entry is used to represent data stored by Vault in each Key/Value Pair
type Entry struct {
	Key   string
	Value []byte
}

// Operation - The operation enum
type Operation string

// operation enum value
const (
	// DeleteOperation ...
	DeleteOperation Operation = "delete"
	// GetOperation ...
	GetOperation = "get"
	// ListOperation ...
	ListOperation = "list"
	// PutOperation ...
	PutOperation = "put"
)

// GenericTransactionHandler - Implements the transaction interface
// func (t PseudoTransactional)GenericTransactionHandler(ctx context.Context txns []*TxnEntry) (retErr error) {
func (b *Backend) GenericTransactionHandler(ctx context.Context, txns []*TxnEntry) (retErr error) {
	rollbackStack := make([]*TxnEntry, 0, len(txns))
	var dirty bool

	// We walk the transactions in order; each successful operation goes into a
	// LIFO for rollback if we hit an error along the way
TxnWalk:
	for _, txn := range txns {
		switch txn.Operation {
		case DeleteOperation:
			entry, err := b.GetInternal(ctx, txn.Entry.Key)
			if err != nil {
				retErr = stacktrace.Propagate(err, "Transactional Delete operation failed because an entry with key [%s] was not found", txn.Entry.Key)
				dirty = true
				break TxnWalk
			}
			if entry == nil {
				// Nothing to delete or roll back
				continue
			}
			rollbackEntry := &TxnEntry{
				Operation: PutOperation,
				Entry:     &Entry{
					// Key:   entry.Key,
					// Value: entry.Value,
				},
			}
			err = b.DeleteInternal(ctx, txn.Entry.Key)
			if err != nil {
				retErr = stacktrace.Propagate(err, "Transactional Delete operation failed")
				dirty = true
				break TxnWalk
			}
			rollbackStack = append([]*TxnEntry{rollbackEntry}, rollbackStack...)

		case PutOperation:
			entry, err := b.GetInternal(ctx, txn.Entry.Key)
			if err != nil {
				retErr = stacktrace.Propagate(err, "Transactional Put operation failed because an entry with key [%s] was not found", txn.Entry.Key)
				dirty = true
				break TxnWalk
			}
			// Nothing existed so in fact rolling back requires a delete
			var rollbackEntry *TxnEntry
			if entry == nil {
				rollbackEntry = &TxnEntry{
					Operation: DeleteOperation,
					Entry: &Entry{
						Key: txn.Entry.Key,
					},
				}
			} else {
				rollbackEntry = &TxnEntry{
					Operation: PutOperation,
					Entry:     &Entry{
						// Key:   entry.Key,
						// Value: entry.Value,
					},
				}
			}

			err = b.PutInternal(ctx, txn.Entry, "", "2")
			if err != nil {
				retErr = stacktrace.Propagate(err, "Transactional Put operation failed")
				dirty = true
				break TxnWalk
			}
			rollbackStack = append([]*TxnEntry{rollbackEntry}, rollbackStack...)
		}
	}

	// Need to roll back because we hit an error along the way
	if dirty {
		// While traversing this, if we get an error, we continue anyways in
		// best-effort fashion
		for _, txn := range rollbackStack {
			switch txn.Operation {
			case DeleteOperation:
				err := b.DeleteInternal(ctx, txn.Entry.Key)
				if err != nil {
					retErr = stacktrace.Propagate(err, "Roll Back of Delete operation for key [%s] failed", txn.Entry.Key)
				}
			case PutOperation:
				err := b.PutInternal(ctx, txn.Entry, "", "2")

				if err != nil {
					retErr = stacktrace.Propagate(err, "Roll Back of Put operation for key [%s] failed", txn.Entry.Key)
				}
			}
		}
	}

	return
}

// Prefixes is a shared helper function returns all parent 'folders' for a
// given vault key.
// e.g. for 'foo/bar/baz', it returns ['foo', 'foo/bar']
func Prefixes(s string) []string {
	components := strings.Split(s, "/")
	result := []string{}
	for i := 1; i < len(components); i++ {
		result = append(result, strings.Join(components[:i], "/"))
	}
	return result
}
