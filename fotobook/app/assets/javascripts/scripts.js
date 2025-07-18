document.addEventListener('turbo:load', () => {
    const postImages = document.getElementsByClassName('photo-image');
    const postTitles = document.getElementsByClassName('photo-title');
    const postDescriptions = document.getElementsByClassName('photo-description');
    for (let idx = 0; idx < postImages.length; idx++) {
        postImages[idx].addEventListener('click', () => {
            const modalTitle = document.getElementById('photo-title');
            const modalDescription = document.getElementById('photo-description');
            const modalImage = document.getElementById('photo-image');
            modalTitle.textContent = postTitles[idx].textContent;
            modalDescription.textContent = postDescriptions[idx].textContent;
            modalImage.src = postImages[idx].src;
        });
    }

    const google = document.getElementById("google");
    if (google) {
        google.addEventListener("click", () => {
            window.open("https://accounts.google.com/signin");
        });
    }

    const facebook = document.getElementById("facebook");
    if (facebook) {
        facebook.addEventListener("click", () => {
            window.open("https://facebook.com/login");
        });
    }

    const x = document.getElementById("X");
    if (x) {
        x.addEventListener("click", () => {
            window.open("https://x.com/i/flow/login");
        });
    }

    document.querySelectorAll('.album-image').forEach(img => {
        img.addEventListener('click', () => {
            document.getElementById('album-title').textContent = img.dataset.title;
            document.getElementById('album-description').textContent = img.dataset.description;
            const carouselInner = document.querySelector('#carousel .carousel-inner');
            if (carouselInner) {
                const photoUrls = img.dataset.photos.split(';');
                photoUrls.forEach((url, idx) => {
                    const div = document.createElement('div');
                    div.className = 'carousel-item' + (idx === 0 ? ' active' : '');
                    div.innerHTML = `<img src="${url}" class="d-block w-100" alt="Image">`;
                    carouselInner.appendChild(div);
                });
            }
        });
    });
});