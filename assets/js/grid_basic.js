

if(window.location.pathname !== '/grid'){
  throw new Error("bad path")
}


import {Socket} from "phoenix"

let socket_grid = new Socket("/socket", {params: {token: window.userToken}})
socket_grid.connect()

let channel = socket_grid.channel("grid:lobby", {})



let player_id = null;

channel.join()
  .receive("ok", resp => {
    console.log("Joined Grid Channel successfully", resp)
    player_id = resp.player_id;
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

  
//channel.on("heartbeat", payload => {
//
//)

import React from 'react';
import ReactDOM from 'react-dom';

import { Grid, Col, Row, Button } from 'react-bootstrap';

var contents = [["a","b","cdcd","adada"],["cc","dd"]]


class Square extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        isHovered: false
      }

      this.handleHover = this.handleHover.bind(this)
      this.btnClick = this.btnClick.bind(this)
  }

  btnClick(pos){
    console.log("move to pos" + pos)

    channel.push("new_pos",
        {body: {grid_pos: pos,
                move_type: 0}}
    )
  }

  handleHover(){
    this.setState({
        isHovered: !this.state.isHovered
    });
  }

  render(){
    let divClass = this.state.isHovered ? "grid-square-hover" : "grid-square ";

    return (
        <div className={divClass}  onMouseEnter={this.handleHover} onMouseLeave={this.handleHover}>
          {this.props.players}

          { this.props.food }

          <button onClick={() => this.btnClick(this.props.pos)} className="btn btn-primary"> Set position</button>
        </div>

    )
  }
}

class GameBox extends React.Component {

  constructor(props) {
      super(props);
      this.state = {
        grid: [3,3,3],
        gridspots: [[1,2,3]],
        player_pos: 0,
        players: [],
        loading: true
      }
  }

  componentDidMount() {
    console.log("box mounted")
    channel.on("heartbeat", payload => {
        console.log("got heartbeat channel from server")
        this.setState({
          gridspots: payload.gridspots,
          gru: payload.gru,
          players: payload.players,
          loading: false
        });

      console.log(payload);
      }
    )



  }

	render(){

      if(this.state.loading){
        return (
            <div className="loader">Loading...</div>
        )
      }

      let player_keys = Object.keys(this.state.players);

       let player_list = (
        <ul>
          {player_keys.map((key, i) => (
              <li key={i + "-playerlist"}>
                <div>
                player: {this.state.players[key].name} {key}
                  pos: {this.state.players[key].pos}
                  </div>
              </li>
          ))}
        </ul>
    )

    let player_map = []
    for( let i = 0; i < 20; i++){
      player_map.push(new Object({residents: []}));
    }
    player_keys.map((key) => {
      let pos = this.state.players[key].pos
      let name = this.state.players[key].name
      player_map[pos]["residents"].push(name)
    })



		 	return(
		 		<div>
          {player_list}


          <Grid>
            <Row className="show-grid">
    {this.state.gridspots.map((object, i) => {

      let colClass = "grid-square"

      let has_gru = null;
      if(this.state.gru && i == this.state.gru.pos) {
        has_gru = (
            <div> <h4>Gru: {this.state.gru.hp}</h4>
            </div>
        )
        colClass = "grid-square-gru-occupied"
      }



      if( this.state.players[player_id] &&
          i == this.state.players[player_id].pos) {
        colClass = "grid-square-player-occupied"
      }

      return (

              <Col className={colClass} xs={12} md={2} key={"inner"+i} >
                <h3> {i} </h3>
                {has_gru}
                <div className="other-player-tile">
                  <h4>{ player_map[i].residents.toString()} </h4>
                </div>

                <Square food={object.food} pos={i} />
                {object.infotype}
              </Col>
          )
        }
    )}
        </Row>


</Grid>
				</div>
			)
	}
}





ReactDOM.render(
  <div>
    <h1>Grid basic</h1>
    <GameBox />

  </div>,
  document.getElementById('gridroot')
);

