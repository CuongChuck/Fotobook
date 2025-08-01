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
                const photoUrls = img.dataset.images.split(';');
                photoUrls.forEach((url, idx) => {
                    const div = document.createElement('div');
                    div.className = 'carousel-item' + (idx === 0 ? ' active' : '');
                    div.innerHTML = `<img src="${url}" class="d-block w-100" alt="Image">`;
                    carouselInner.appendChild(div);
                });
            }
        });
    });

    const albumModal = document.getElementById('album-content');
    if (albumModal) {
        albumModal.addEventListener('hidden.bs.modal', () => {
            const carouselInner = document.querySelector('#carousel .carousel-inner');
            if (carouselInner) carouselInner.innerHTML = '';
        });
    }

    const input = document.getElementById('avatar-upload-user');
    const image = document.getElementById('avatar-upload-image-user');
    if (input && image && input.className != "images-upload") {
        input.addEventListener('change', () => {
            image.src = URL.createObjectURL(input.files[0]);
        });
    }

    const imagesAlbum = document.getElementsByClassName('images-upload')[0];
    if (imagesAlbum) {
        imagesAlbum.addEventListener('change', (e) => {
            if (window.File && window.FileReader && window.FileList && window.Blob) {
                const files = e.target.files;
                const container = document.querySelector('.album-images');
                container.innerHTML = '';
                for (let file of files) {
                    const reader = new FileReader();
                    reader.addEventListener('load', (event) => {
                        const pic = event.target;
                        if (container) {
                            const img = document.createElement('img');
                            img.className = "col col-xl-3 col-md-4 col-6";
                            img.src = pic.result;
                            container.appendChild(img);
                        }
                    });
                    reader.readAsDataURL(file);
                }
            }
            else {
                alert('The File APIs are not fully supported in this browser.');
            }
        });
    }
    
    const toastElList = document.querySelectorAll(".toast");
    toastElList.forEach(toastEl => {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    });
});