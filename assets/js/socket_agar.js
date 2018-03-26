// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket_agar = {}
if(window.location.pathname == '/blob'){

let socket_agar = new Socket("/socket_agar", {params: {token: window.userToken}})

let channel = socket_agar.channel("agar:lobby", {})
let chatInput         = document.querySelector("#agar-input")
let messagesContainer = document.querySelector("#input-log")

chatInput.addEventListener("keypress", event => {
  console.log("pressed enter22")
  if(event.keyCode === 13){
    channel.push("new_msg", {body: chatInput.value})
    chatInput.value = ""
  }
})

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li");
  messageItem.innerText = `[${Date()}] ${payload.body}`
  messagesContainer.appendChild(messageItem)
})


channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
}

export default socket_agar
