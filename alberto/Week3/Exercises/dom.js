const sec = document.querySelector('section');
const div = document.createElement("div");

const wordInput = document.querySelector('input');

const reverseButton = document.querySelector('button');
const ul = document.createElement('ul');

reverseButton.textContent = 'Reverse';
reverseButton.onclick = () => {
    const reverseWord = document.createElement('li');
    reverseWord.textContent = revertString(wordInput.value);
    wordInput.value = "";
    ul.appendChild(reverseWord);

}

div.appendChild(ul);
sec.appendChild(div);


function revertString(word) {
    return word.split('').reverse().join('');
}
