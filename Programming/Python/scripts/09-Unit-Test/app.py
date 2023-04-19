def sum(a,b):
    if isinstance(a, int) and isinstance(b, int):
        return a + b
    else:
        raise TypeError