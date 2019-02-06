import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
    console.log("Game init");
    channel.join()
        .receive("ok", resp => {
            console.log("Joined successfully", resp)
            ReactDOM.render(<GameBoard channel={channel} game={resp.game}/>, root);
        })
        .receive("error", resp => {
            console.log("Unable to join", resp)
        });
}

class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.channel = props.channel;
        this.state = props.game;
        this.channel.on("update", resp => {
            this.update(resp)
        });
    }

    // updates the board with the new game state
    update(response) {
        console.log("update", response);
        this.setState(response.game);
    }

    // handles a click at the given location, informing the channel of the change
    tileClicked(index) {
        this.channel.push("click", {index: index})
            .receive("error", resp => {
                console.log(resp);
            });
    }

    // resets the game and creates a new board
    reset() {
        this.channel.push("reset")
            .receive("error", resp => {
                console.log(resp);
            });
    }

    render() {
        if (!this.state.board && this.state.clicks) {
            return null;
        }

        let board = _.chunk(this.state.board, 4);
        let rows = _.map(board, (row, i) => {
            let tiles = _.map(row, (tile) => {
                let handler = () => {
                    this.tileClicked(tile.index)
                };
                return <Tile key={tile.index} tile={tile} clickHandler={handler}/>;
            });
            return <div key={"row" + i} className={"row"}>{tiles}</div>;
        });

        return <div>
            <h1 className="title">Memory Game</h1>
            <div>
                <h2 className="title clicks">Clicks: {this.state.clicks}</h2>
                <Reset clickHandler={this.reset.bind(this)}/>
            </div>
            <div className="container">{rows}</div>
        </div>;
    }
}

function Tile(props) {
    let {tile, clickHandler} = props;

    let content;

    if (tile.state === "hidden") {
        content = <div className={tile.state} onClick={clickHandler}/>;
    } else {
        content = <div className={tile.state}><p>{tile.letter}</p></div>
    }

    return <div className="column tile">
        {content}
    </div>;
}

function Reset({clickHandler}) {
    return <button onClick={clickHandler} className={"reset"}>Reset</button>;
}

