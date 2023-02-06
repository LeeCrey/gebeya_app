
window.onload = function () {
    const slides = document.getElementsByClassName("mySlides");
 
    // const next = document.getElementById('show_more');
    // const prev = document.getElementById('back_one');

    let slideIndex = 0;
    let timeoutId = null;
  
    showSlides();
  
    function plusSlides(step) {
      slideIndex += 1;
  
      showSlides();
    }
  
    function showSlides() {
      for (let i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";
      }
      
      slideIndex++;
      if (slideIndex > slides.length) {
        slideIndex = 1;
      }

      slides[slideIndex - 1].style.display = "block";
      if (timeoutId) {
        clearTimeout(timeoutId);
      }

      timeoutId = setTimeout(showSlides, 5000); // Change image every 5 seconds
    }

    // next.onclick = function() {
    //   plusSlides(1);
    // }

    // prev.onclick = function() {
    //   plusSlides(-1);
    // }
  };
  