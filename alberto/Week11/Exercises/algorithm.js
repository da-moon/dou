const romanNumbers  = {
    I: 1,
    V: 5,
    X: 10,
    L: 50,
    C: 100,
    D: 500,
    M: 1000,
}

function toDecimal(input) {
    let total=0;
    
    for (let i=0; i< input.length; i++){
        if (romanNumbers[input.toUpperCase()[i]] >= romanNumbers[input.toUpperCase()[i+1]]){
            total += romanNumbers[input.toUpperCase()[i]];
        } else if (romanNumbers[input.toUpperCase()[i]] < romanNumbers[input.toUpperCase()[i+1]])  {
            let specialNumber = romanNumbers[input.toUpperCase()[i+1]] - romanNumbers[input.toUpperCase()[i]]
            total += specialNumber;
            i++;
        } else {
            total += romanNumbers[input.toUpperCase()[i]];
        }
    };
    return total;
}

console.log(toDecimal("LVIII"));
console.log(toDecimal("MCMXCIV"));