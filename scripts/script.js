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
                    <a href="${isLogin ? "" : "./index.html"}"><h4 class="my-2">${"Fotobook" + isAdmin}</h4></a>
                </div>
                <div class="col col-3 col-xl-4">
                    <input class="rounded form-control-sm px-3 w-100" placeholder="Search Photo / Album"></input>
                </div>
                <div class="col offset-1 offset-md-2 col-2 d-flex flex-row justify-content-center align-items-center">
                    ${
                        isLogin ?
                        `<ava-style dark="true"></ava-style>
                        <h6 class="my-auto mx-3">User</h6>` :
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
        this.innerHTML =
            `<div class="d-flex flex-column">
                ${isAdmin ?
                    `<a current="true" href="#">Manage Photos</a>
                    <a href="#">Manage Albums</a>
                    <a href="#">Manage Users</a>` :
                    `<a href="#">Feeds</a>
                    <a href="#">Discover</a>`
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
        this.innerHTML = `
            <input type="checkbox" class="btn-check follow-input" id="follow-check" autocomplete="off">
            <label id="follow-button" class="btn follow-label rounded-pill p-1" for="follow-check">follow</label>
        `;
        const checkbox = this.querySelector('#follow-check');
        const label = this.querySelector('label');
        label.addEventListener('click', () => {
            label.textContent = checkbox.checked ? "follow" : "following";
        })
    }
}

class Post extends HTMLElement {
    constructor() { super(); }
    connectedCallback() {
        const follow = this.getAttribute('follow') == "true" ? true : false
        this.innerHTML = `
            <div class="d-flex flex-row bg-body-secondary p-1 post my-2 mx-2">
                <img class="w-50 h-100" src="../../res/penguin.png">
                <div class="container d-grid pe-1">
                    <div class="d-flex flex-row justify-content-between align-items-center">
                        <div class="d-flex flex-row">
                            <ava-style></ava-style>
                            <h6 class="my-auto mx-2 postor">User</h6>
                        </div>
                        ${follow ? `<follow-button></follow-button>` : ``}
                    </div>
                    <h5 class="fs-5 mt-2 text-center">Title</h5>
                    <p>Description</p>
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

document.addEventListener('DOMContentLoaded', () => {
    customElements.define('ava-style', AvaStyle);
    customElements.define('header-fotobook', Header);
    customElements.define('nav-bar', NavigationBar);
    customElements.define('authorize-button', AuthorizeButton);
    customElements.define('mode-switch', Switch);
    customElements.define('follow-button', FollowButton);
    customElements.define('user-post', Post);
    customElements.define('media-manager', MediaManager);

    document.getElementById("google").addEventListener("click", () => {
        window.open("https://accounts.google.com/signin", '_blank');
    });

    document.getElementById("facebook").addEventListener("click", () => {
        window.open("https://facebook.com/login", '_blank');
    });

    document.getElementById("X").addEventListener("click", () => {
        window.open("https://x.com/i/flow/login", '_blank');
    });
});