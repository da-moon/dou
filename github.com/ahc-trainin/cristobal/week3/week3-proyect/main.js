const slider = document.getElementById('slider'); 
const sliderImages = ['(./imgs/house2.jpg', './img/house3.jpg', './img/house4.jpg', '.img/house5.jpg' ]; 
slider.setAttribute('src', sliderImages[sliderCount])

slider.onclick=() => { 
    if (sliderCount === 2){ 
        sliderCount = 0; 
    }
    else { 
        sliderCount++; 
    }
    slder.setAttribute('src', sliderImages[sliderCount])
}



function myFunction() {
    let name = document.getElementById("Name").value;
    document.getElementById("demoName").innerHTML = name;
    let contactEmail = document.getElementById("Email").value;
    document.getElementById("demoEmail").innerHTML = contactEmail;
    let subject = document.getElementById("Subject").value;
    document.getElementById("demoSubject").innerHTML = subject;
    let comment = document.getElementById("Comment").value;
    document.getElementById("demoComment").innerHTML = comment;
  }