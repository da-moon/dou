# geohash

Simple implementation of GeoHash algorithm for tech talk.

> Geohash is a public domain geocode system invented in 2008 by Gustavo Niemeyer[1], which encodes a geographic location into a short string of letters and digits. It is a hierarchical spatial data structure which subdivides space into buckets of grid shape, which is one of the many applications of what is known as a Z-order curve, and generally space-filling curves.
>
> *from [Wikipedia](https://en.wikipedia.org/wiki/Geohash)*

---

## Author
Guillermo Estrada (guillermo.estrada@digitalonus.com)  
Original repository - https://github.com/phrozen/geohash

---

## Usage

For complete usage, check the docs: 

### Encode

```go
// Encode arbitrary coordinates with precision 9
hash := geohash.Encode(20.71263947, -103.40978912, 9) // 9ewmyfe7c
```

### Decode

```go
// Decode geohash into a region
region := geohash.Decode("9ewmyfe7c")
location := region.Center() // {20.71264, -103.409779}
```


