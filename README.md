# Hello Allegro

This is a template for C++ projects using [Allegro](https://liballeg.org/)

## Building

```bash
cmake -B build
cmake --build build
./bin/hello-allegro
```

Don't have Allegro? You can build that too:
```bash
cmake -B build -DBUILD_ALLEGRO=ON
```
To build Allegro on windows, you need the old [DirectX SDK](https://www.microsoft.com/en-us/download/details.aspx?id=6812).

