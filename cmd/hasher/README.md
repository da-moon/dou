# hasher
Simple CLI file hashing utility for security and file integrity purposes. Nice exercise for learning Golang std lib interfaces like `io.Writer`, `hash.Hash` and the `flag` package. 

### Author
Guillermo Estrada (guillermo.estrada@digitalonus.com)

### Install
Make sure you have your default `$GOBIN` or `$GOROOT/bin` variables on your `$PATH`

```
go install github.com/DigitalOnUs/go-dev/cmd/hasher
```

### Usage

```
Usage of hasher: 
> hasher <flags> </path/to/file.ext>
  -md5
        Calculates md5 hash of file
  -sha1
        Calculates sha1 hash of file
  -sha256
        Calculates sha256 hash of file
  -sha512
        Calculates sha512 hash of file
```

### Example

```
> hasher -md5 -sha1 -sha256 hasher.go
   md5: 601c98553f56951ddbdce01eb21d77da
  sha1: 17c047227809d53f372310fc024fad782d841280
sha256: b536483e326449391e6ece869b36cc4b810acc09966837ad82a547e4649ad060
```
