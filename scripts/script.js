class AvaStyle extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <div class="rounded-circle avatar p-1">AD</div>
        `;
    }
}

class Header extends HTMLElement {
    constructor() { super(); }

    connectedCallback() {
        const isAdmin = this.getAttribute("admin") == "true" ? " Admin" : "";
        const isLogin = this.getAttribute("login") == "true" ? true : false;
        this.innerHTML = `
            <header class="d-flex flex-row align-items-center text-center">
                <div class="col col-4 col-md-3 col-xl-2">
                    <a href="${isLogin ? "./feed.html" : "./index.html"}"><h4 class="my-2">${"Fotobook" + isAdmin}</h4></a>
                </div>
                <div class="col col-3 col-xl-4">
                    <input class="rounded form-control-sm px-3 w-100" placeholder="Search Photo / Album"></input>
                </div>
                <div class="col offset-1 offset-md-2 col-2 d-flex flex-row justify-content-center align-items-center">
                    ${
                        isLogin ?
                        `<a href="./profile-self.html" class="d-flex flex-row"><ava-style dark="true"></ava-style>
                        <h6 class="my-auto mx-3">User</h6></a>` :
                        ``
                    }
                </div>
                <div class="col col-2">
                    <a class="my-2" href="${isLogin ? "../guest/index.html" : "./login.html"}">${isLogin ? "Logout" : "Login"}</a>
                </div>
            </header>
        `;
    }
}

class NavigationBar extends HTMLElement {
    constructor() { super(); }

    connectedCallback() {
        const isAdmin = this.getAttribute('admin') == "true" ? true : false
        const page = this.getAttribute('page');
        this.innerHTML =
            `<div class="d-flex flex-column">
                ${isAdmin ?
                    `<a current="${page == "photo" ? "true" : "false"}" href="./manage-photo.html">Manage Photos</a>
                    <a current="${page == "album" ? "true" : "false"}" href="./manage-album.html">Manage Albums</a>
                    <a current="${page == "user" ? "true" : "false"}" href="./manage-user.html">Manage Users</a>` :
                    `<a current="${page == "feed" ? "true" : "false"}" href="./feed.html">Feeds</a>
                    <a current="${page == "discover" ? "true" : "false"}" href="./discover.html">Discover</a>`
                }
            </div>`
        ;
    }
}

class AuthorizeButton extends HTMLElement {
    constructor() { super(); }

    connectedCallback() {
        const isLogin = this.getAttribute("login") === "true";
        this.innerHTML = `
            <button class="authorize-button btn px-4 mt-3">${isLogin ? "Login" : "Signup"}</button>
        `;
    }
}

class Switch extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <div class="d-flex flex-row justify-content-center mb-2">
                <input type="radio" class="btn-check mode-radio" name="view-mode" id="photo" autocomplete="off" checked>
                <label id="mode-button" class="btn mode" for="photo">PHOTO</label>

                <input type="radio" class="btn-check mode-radio" name="view-mode" id="album" autocomplete="off">
                <label id="mode-button" class="btn mode" for="album">ALBUM</label>
            </div>
        `;
    }
}

class FollowButton extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const follow = this.getAttribute('follow') == "true" ? true : false;
        const unfollow = this.getAttribute('unfollow') == 'true' ? true : false;
        const uniqueId = `follow-check-${Math.random().toString(36).slice(2, 11)}`;
        this.innerHTML = `
            <input type="checkbox" class="btn-check follow-input" id="${uniqueId}" autocomplete="off" ${follow ? `checked` : ``}>
            <label id="follow-button" class="btn follow-label rounded-pill p-1" for="${uniqueId}">${follow ? `following` : `follow`}</label>
        `;
        const checkbox = this.querySelector('.follow-input');
        const label = this.querySelector('label');
        if (unfollow) label.textContent = "unfollow";
        label.addEventListener('click', () => {
            label.textContent = checkbox.checked ? "follow" : "following";
        });
    }
}

class Post extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const follow = this.getAttribute('follow') == "true" ? true : false
        this.innerHTML = `
            <div class="d-flex flex-row bg-body-secondary p-1 post my-2 mx-2">
                <img class="w-50 h-100 post-image" src="../../res/penguin.png" data-bs-toggle="modal" data-bs-target="#post-content">
                <div class="container d-grid pe-1">
                    <div class="d-flex flex-row justify-content-between align-items-center">
                        <div class="d-flex flex-row">
                            <ava-style></ava-style>
                            <a href="./profile.html" class="my-auto mx-2"><h6 class="my-auto postor">User</h6></a>
                        </div>
                        ${follow ? `<follow-button></follow-button>` : ``}
                    </div>
                    <h5 class="fs-5 mt-2 text-center post-title">Title</h5>
                    <p class="post-description">Description</p>
                    <div class="d-flex flex-row justify-content-between align-items-center align-self-end">
                        <div class="d-flex flex-row align-items-center">
                            <i class="fa-solid fa-heart fa-xs like me-1"></i>
                            <span>123</span>
                        </div>
                        <p class="time my-0">9:53 am 07/07/2007</p>
                    </div>
                </div>
            </div>
        `;
        const likeButton = this.querySelector('.like');
        likeButton.addEventListener('click', () => {
            const color = likeButton.style.color;
            likeButton.style.color = color == "var(--primary)" ? "var(--notlike)" : "var(--primary)";
        });
        const postImage = this.querySelector('.post-image');
        const postTitle = this.querySelector('.post-title');
        const postDescription = this.querySelector('.post-description');
        postImage.addEventListener('click', () => {
            const modalTitle = document.getElementById('modal-title');
            const modalDescription = document.getElementById('modal-description');
            const modalImage = document.getElementById('modal-image');
            modalTitle.textContent = postTitle.textContent;
            modalDescription.textContent = postDescription.textContent;
            modalImage.src = postImage.src;
        });
    } 
}

class MediaManager extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <div class="media-manager-container position-relative w-75 mb-2">
                <img class="w-100" src="../../res/penguin.png">
                <div class="title-panel position-absolute top-0 start-0 w-100 px-2 py-1 d-flex flex-row align-items-center justify-content-between">
                    <span class="text-white overflow-hidden me-2">Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</span>
                    <i class="text-white fa-regular fa-pen-to-square"></i>
                </div>
            </div>
        `;
    }
}

class EditHeader extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <div class="d-flex flex-row align-items-center justify-content-between">
                <h6 class="fw-bold fs-5">${this.getAttribute('title')}<h6>
                <button onclick="history.back()" class="btn rounded-1 back-btn">Back</button>
            </div>
            <div class="border border-1 mt-1"></div>
        `;
    }
}

class Modal extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <div class="modal fade" tabindex="-1" aria-hidden="true" id="post-content">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 id="modal-title" class="m-0"></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <img alt="Post content" id="modal-image" class="w-100 mb-3">
                            <p id="modal-description"></p>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
}

class Pagination extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        this.innerHTML = `
            <nav class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link">Previous</a>
                    </li>
                    <li class="page-item active">
                        <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">2</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">3</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#">Next</a>
                    </li>
                </ul>
            </nav>
        `;
    }
}

class Profile extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const isPublic = this.getAttribute('public') == "true" ? true : false;
        const page = this.getAttribute('page');
        this.innerHTML = `
            <div class="d-flex flex-row">
                <img class="rounded-circle h-25 me-4" src="../../res/penguin.png">
                <div class="d-flex flex-column">
                    ${
                        isPublic ?
                        `<follow-button class="fs-6"></follow-button>`
                        :
                        `<a href="./edit-user.html"><button class="btn edit-profile-button rounded-pill py-1">Edit Profile</button></a>`
                    }
                    <h1 class="text-black my-3">Hansford Nguyen</h1>
                    <div class="d-flex flex-wrap">
                        <a href=${isPublic ? "./profile.html" : "./profile-self.html"} class="profile-tab" select=${page == "photo" ? "true" : "false"}><span class="fs-3">108</span> PHOTOS</a>
                        <div class="border-start mx-lg-3 mx-2"></div>
                        <a href=${isPublic ? "./profile-album.html" : "./profile-self-album.html"} class="profile-tab" select=${page == "album" ? "true" : "false"}><span class="fs-3">108</span> ALBUMS</a>
                        <div class="border-start mx-lg-3 mx-2"></div>
                        <a href=${isPublic ? "./profile-following.html" : "./profile-self-following.html"} class="profile-tab" select=${page == "following" ? "true" : "false"}><span class="fs-3">108</span> FOLLOWINGS</a>
                        <div class="border-start mx-lg-3 mx-2"></div>
                        <a href=${isPublic ? "./profile-follower.html" : "./profile-self-follower.html"} class="profile-tab" select=${page == "follower" ? "true" : "false"}><span class="fs-3">108</span> FOLLOWERS</a>
                    <div>
                </div>
            </div>
        `;
    }
}

class ProfileMedia extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const isPrivate = this.getAttribute('private') == 'true' ? true : false;
        const isSelf = this.getAttribute('self') == 'true' ? true : false;
        const isAlbum = this.getAttribute('album') == 'true' ? true : false;
        this.innerHTML = `
            <div class="m-3">
                <div class="position-relative">
                    <img class="rounded w-100" src="../../res/penguin.png">
                    ${ isPrivate ? `<i class="fa-solid fa-lock bg-white position-absolute rounded-circle p-1 top-0 end-0"></i>` : ``}
                    ${ isSelf ? `<a href=${isAlbum ? "./edit-album.html" : "./edit-photo.html"}><button class="btn edit-media-button rounded-pill position-absolute bottom-0 end-0 py-0 px-1 text-white">EDIT</button></a>` : ``}
                    ${ isAlbum ?
                        `<div class="rounded-circle fw-bold p-3 photo-counter position-absolute top-50 start-50 translate-middle text-center text-white">
                            <div class="m-0 fs-2">10</div>
                            <div class="fs-lg-2 fs-sm-4">PHOTOS</div>
                        </div>` : ``
                    }
                </div>
                <div class="text-center mt-2">Title</div>
            </div>
        `;
    }
}

class ProfileFollow extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const unfollow = this.getAttribute('unfollow');
        this.innerHTML = `
            <div class="bg-body-tertiary rounded mx-1 my-4 py-3 d-flex flex-column align-items-center">
                <img src="../../res/penguin.png" class="rounded-circle w-50">
                <h5 class="text-dark mt-1">User</h5>
                <div class="d-flex flex-row justify-content-center gap-4 mb-2">
                    <div class="text-center fs-3 fw-bold tagnum">22<div class="tag fw-normal">PHOTOS</div></div>
                    <div class="text-center fs-3 fw-bold tagnum">105<div class="tag fw-normal">ALBUMS</div></div>
                </div>
                <follow-button follow=${this.getAttribute('follow')} unfollow=${unfollow}></follow-button>
            </div>
        `;
        if (unfollow == "true") {
            const follow = this.querySelector("follow-button");
            follow.addEventListener('click', () => {
                this.style.display = "none";
            });
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    customElements.define('ava-style', AvaStyle);
    customElements.define('header-fotobook', Header);
    customElements.define('nav-bar', NavigationBar);
    customElements.define('authorize-button', AuthorizeButton);
    customElements.define('mode-switch', Switch);
    customElements.define('follow-button', FollowButton);
    customElements.define('user-post', Post);
    customElements.define('media-manager', MediaManager);
    customElements.define('edit-header', EditHeader);
    customElements.define('pagi-nation', Pagination);
    customElements.define('post-modal', Modal);
    customElements.define('profile-header', Profile);
    customElements.define('profile-media', ProfileMedia);
    customElements.define('profile-follow', ProfileFollow);
});