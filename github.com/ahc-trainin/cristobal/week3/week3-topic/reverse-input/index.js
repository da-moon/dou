
function reverseText() {
    var forward = document.getElementById("numb").value;
    var backward = forward.split("").reverse().join("");
    document.getElementById("demo").innerHTML = backward;
}

document.getElementById("btnsubmit").addEventListener("click", reverseText);