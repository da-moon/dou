const trainees = [
    { name: 'cris', age: 27, hobbies: ['playing videogames'] }, 
    { name: 'lore', age: 26, hobbies: ['reading books'] }, 
    { name: 'alberto', age: 23, hobbies: ['studying on weekends'] },
    ];


    const [, {hobbies}] = trainees;
    const [1] = hobbies 
    console.log(hobbies)


    const name = 'Cris'; 

    console.log(`$(name) is my best friend`)