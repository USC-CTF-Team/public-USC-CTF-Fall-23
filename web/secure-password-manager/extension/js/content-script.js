function get_email_input() {
    if (document.querySelector("input[type=email]") !== null) {
        return document.querySelector("input[type=email]");
    }
    return document.querySelector("input[name=email]");
}

function get_password_input() {
    if (document.querySelector("input[type=password]") !== null) {
        return document.querySelector("input[type=password]");
    }
    return document.querySelector("input[name=password]");
}

function get_submit_btn() {
    if (document.querySelector("button[type=submit]") !== null) {
        return document.querySelector("button[type=submit]");
    }
    return document.querySelector("input[type=submit]");
}

async function main() {
    let email_input = null;
    let password_input = null;
    let submit_btn = null;
    while (email_input === null || password_input === null || submit_btn === null) {
        email_input = get_email_input();
        password_input = get_password_input();
        submit_btn = get_submit_btn();
        await new Promise(r => setTimeout(r, 100));
    }

    let list_credentials = () => {
        chrome.runtime.sendMessage({ action: "get_credentials", host: window.location.host }, (response) => {
            if (!response || response.result !== "success") {
                return;
            }
            let credentials = response.credentials;
            let credentials_select = document.createElement("select");
            credentials_select.style.margin = "10px";
            credentials_select.className = "secure-select"
            credentials_select.innerHTML = `<option value=":" id="empty">Select stored credentials</option>`;
            for (let credential of credentials) {
                credentials_select.innerHTML +=`<option value="${credential.email}:${credential.password}">
                ${credential.email} [${credential.host}]</option>`
            }
            credentials_select.addEventListener("change", (e) => {
                let [email, password] = e.target.value.split(":");
                email_input.value = email;
                password_input.value = password;
            });    
            let old_select = document.querySelector(".secure-select");
            if (old_select !== null) {
                let old_texts = [...old_select.children].map((c) => c.text);
                let new_texts = [...credentials_select.children].map((c) => c.text);
                let changed_text = new_texts.find((t) => !old_texts.includes(t));
                if (changed_text.length == 0) {
                    return;
                }
                let changed_i = [...credentials_select.children].find((c) => c.text == changed_text).index;
                credentials_select.selectedIndex = changed_i;
                old_select.replaceWith(credentials_select);
            } else {
                submit_btn.insertAdjacentElement("afterend", credentials_select);
            }
        });
    }

    submit_btn.addEventListener("click", (_) => {
        let email = email_input.value;
        let password = password_input.value;
        let host = window.location.host;
        let select = document.querySelector(".secure-select");
        if (select !== null && select.options[select.selectedIndex].id !== "empty") {
            let original_email = select.options[select.selectedIndex].text;
            chrome.runtime.sendMessage({ action: "change_credentials", original_email, host, email, password },
            (_) => list_credentials()
        );
        } else {
            chrome.runtime.sendMessage({ action: "store_credentials", host, email, password },
            (_) => list_credentials());
        }
    });

    list_credentials();
}

window.addEventListener("load", main);