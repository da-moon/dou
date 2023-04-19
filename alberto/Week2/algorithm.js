function encode(text) {
    let encode="";

    let map = {};

    for(let i=0; i < text.length; i++){
      let current = text[i];
      let previous = text[i-1];
      if(previous && map[current]=== map[previous]){
        map[current] += 1;
      } else {
        map[current] = 1;
      }
    }

  Object.entries(map).forEach(([key,value])=> {
    encode += value + key;
  });

  return encode;
}

console.log(encode("AABBBCCCC"))``;