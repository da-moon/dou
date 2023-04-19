
function encoding(str) {

    let auxVariable = ""; //

    let counter = 0;

    let result = "";

    for (let i = 0; i < str.length; i++) {

        if (auxVariable === "") {
            auxVariable = str[i];
            counter = 1;
        } else {
                if (auxVariable !== str[i]) {
                    result += `${counter}${auxVariable}`;
                    auxVariable = str[i];
                    counter = 1;
                } else {
                    counter++;
                }
        }

    }

    return result + `${counter}${auxVariable}`

}

function decoding(str) {

    let result = "";

    for (let i = 0; i < str.length; i=i+2) {

        const number = parseInt(str[i]);

        const letter = str[i+1];

        for (let j = 0; j < number; j++) {

            result += letter 

        }


    }

    return result

}

console.log(encoding("AAAABBBCCDAA"))
console.log(decoding("4A3B2C1D2A"))