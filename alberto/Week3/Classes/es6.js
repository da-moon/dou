const initArray = [1,2,3];
const [x,y,z] = initArray;

const trainees = [
    {name:'Cris',age:27,hobbies: ['video games']},
    {name:'Lorena',age:26,hobbies: ['movies']},
    {name:'Alberto',age:23,hobbies: ['cooking', 'movies', 'hiking']}
]

const [,,Alberto] = trainees;
const {hobbies} = Alberto

console.log(hobbies);

const trainee = "Alberto";

console.log(`${trainee} is my best friend`);

const sayMyName = (name = 'unknown') => {
    return name;
}

console.log(sayMyName('john'));

const a = 10;

function test() {
    return a;
}

console.log(test());


const array = [];

array.push('hello');
console.log(array);