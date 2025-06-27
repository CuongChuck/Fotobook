class Header extends HTMLElement {
    constructor() {
        super();
    }

    connectedCallback() {
        const isAdmin = this.getAttribute("admin") === "true";
        this.innerHTML = `
            <header class="d-flex flex-row align-items-center text-center">
                <div class="col col-4 col-md-3 col-xl-2">
                    <h4 class="my-2">${"Fotobook" + (isAdmin ? " Admin" : "")}</h4>
                </div>
                <div class="col col-3 col-xl-4">
                    <input class="rounded form-control-sm px-3 w-100" placeholder="Search Photo / Album"></input>
                </div>
                <div class="col offset-1 offset-md-2 col-2 d-flex flex-row justify-content-center">
                    <img class="rounded-circle avatar" src="../res/penguin.png">
                    <h6 class="my-auto mx-3">User</h6>
                </div>
                <div class="col col-2">
                    <h6 class="my-2">Login</h6>
                </div>
            </header>
        `;
    }
}

customElements.define('header-fotobook', Header);