

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

import { Grid, Col, Row, Button } from 'react-bootstrap';

class Box extends React.Component {

  constructor(props) {
      super(props);
      this.state = {
        grid: [3,3,3]
      }
  }

  componentDidMount() {
    console.log("box mounted")
    channel.on("heartbeat", payload => {
        console.log("got heartbeat channel from server")
        this.setState({
          grid: payload.gridlist
        });

      }
    )

  }

	render(){
		 	return(
		 		<div>
				A div { this.state.grid.toString() }
				</div>
			)
	}
}




var contents = [["a","b","cdcd","adada"],["cc","dd"]]
ReactDOM.render(
  <div><h1>Hello, world23!</h1>
    <Box />
  <Grid>
    {contents.map((object, i) => (
        <Row className="show-grid" key={i}>

          {object.map( (inner, j) => (
            <Col xs={12} md={3} key={"inner"+i+"-"+j}>
            blah { inner }
          </Col>
          ))}

        </Row>
        )
      )
    }


  <Row className="show-grid">
    <Col md={6} mdPush={6}>
      <code>&lt;{'Col md={6} mdPush={6}'} /&gt;</code>
    </Col>
    <Col md={6} mdPush={6}>
      <code>&lt;{'Col md={6} mdPush={6}'} /&gt;</code>
    </Col>
    <Col md={6} mdPush={6}>
      <code>&lt;{'Col md={6} mdPush={6}'} /&gt;</code>
    </Col>
    <Col md={6} mdPull={6}>
      <code>&lt;{'Col md={6} mdPull={6}'} /&gt;</code>
    </Col>
  </Row>
</Grid>
  </div>,
  document.getElementById('gridroot')
);

