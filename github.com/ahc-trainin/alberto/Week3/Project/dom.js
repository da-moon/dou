
const carousel = document.getElementById('carousel');
const carouselImages = ['./images/build5.jpg','./images/build4.jpeg','./images/build3.jpeg']
let carouselCount = 0;

carousel.setAttribute('src',carouselImages[carouselCount]);

carousel.onclick = () => {
    if (carouselCount === 2){
        carouselCount = 0;
    } else {
        carouselCount++;
    }
    carousel.setAttribute('src',carouselImages[carouselCount]);
}

const submitButton = document.getElementById('submitButton');

const comments = document.getElementById('comments');

submitButton.onclick = () => {
    const name = document.getElementById('dataForm').elements[0].value;
    const subject = document.getElementById('dataForm').elements[2].value;
    const comment = document.getElementById('dataForm').elements[3].value;

    const cardGrid = document.createElement('div');
    cardGrid.setAttribute('class', 'col-sm-3');
    
    const cardComment = document.createElement('div');
    cardComment.setAttribute('class', 'card');

    const cardBody = document.createElement('div');
    cardBody.setAttribute('class', 'card-body');

    const cardTitle = document.createElement('h5');
    cardTitle.setAttribute('class', 'card-title');
    cardTitle.textContent = name;

    const cardSubtitle = document.createElement('h6');
    cardSubtitle.setAttribute('class', 'card-subtitle mb-2 text-muted');
    cardSubtitle.textContent = subject;

    const cardContent = document.createElement('p');
    cardContent.setAttribute('class', 'card-text');
    cardContent.textContent = comment;

    cardGrid.appendChild(cardComment);
    cardComment.appendChild(cardBody);
    cardBody.appendChild(cardTitle);
    cardBody.appendChild(cardSubtitle);
    cardBody.appendChild(cardContent);
    

    document.getElementById('dataForm').elements[0].value = '';
    document.getElementById('dataForm').elements[1].value = '';
    document.getElementById('dataForm').elements[2].value = '';
    document.getElementById('dataForm').elements[3].value = '';

    comments.appendChild(cardGrid);
}
