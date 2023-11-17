chrome.runtime.onMessage.addListener((request, _, sendResponse) => {
    if (request.action === "store_credentials") {
        store_credentials(request.host, request.email, request.password);
        sendResponse({ result: "success" });
    } else if (request.action === "get_credentials") {
        get_credentials((data) => {
            if (data) {
                sendResponse({ result: "success", credentials: data });
            } else {
                sendResponse({ result: "error", message: "No credentials found" });
            }
        });
        return true;
    } else if (request.action === "change_credentials") {
        change_credentials(request.host, request.original_email, request.email, request.password);
    }
});
function store_credentials(host, email, password) {
    let creds_obj = { host, email, password };
    get_credentials((data) => {
        if (data === null) {
            data = [];
        }
        data.push(creds_obj);
        chrome.storage.local.set({ ["credentials"]: JSON.stringify(data) }, () => { });
    });
}

function get_credentials(callback) {
    chrome.storage.local.get("credentials", (data) => {
        if (data["credentials"] !== undefined) {
            callback(JSON.parse(data["credentials"]));
        } else {
            callback(null);
        }
    });
}

function change_credentials(host, original_email, email, password) {
    let creds_obj = { host, email, password };
    get_credentials((data) => {
        data = data.filter(cred => cred["host"] !== host
            || cred["email"] !== original_email);
        data.push(creds_obj);
        chrome.storage.local.set({ ["credentials"]: JSON.stringify(data) }, () => { });
    });
}
