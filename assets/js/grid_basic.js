

if(window.location.pathname !== '/grid'){
  throw new Error("bad path")
}


import {Socket} from "phoenix"

let socket_grid = new Socket("/socket", {params: {token: window.userToken}})
socket_grid.connect()

let channel = socket_grid.channel("grid:lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("Joined Grid Channel successfully", resp)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

  
//channel.on("heartbeat", payload => {
//
//)


import React from 'react';
import ReactDOM from 'react-dom';

ReactDOM.render(
  <h1>Hello, world!</h1>,
  document.getElementById('gridroot')
);

