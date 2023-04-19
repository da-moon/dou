 //Example

  const obj = {
      a: 1,
      b: 2,
  }

  const array = [1, 2, 3];

  //Mutation

  obj.a = 3;

  array.push(4);

  //Inmutability

  const obj = {...obj, a:3};

  const array = [...array, 4];