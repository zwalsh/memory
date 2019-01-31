import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root) {
    ReactDOM.render(<GameBoard/>, root);
}

class GameBoard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            clicks: 0,
            board: this.genBoard(),
            num_visible: 0,
        };
        console.log("GameBoard made");
    }

    genBoard() {
        let board = [];
        let chars = ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D', 'E', 'E', 'F', 'F', 'G', 'G', 'H', 'H'];

        for (let i = 0; i < 4; i++) {
            let row = [];
            board.push(row);
            for (let j = 0; j < 4; j++) {
                let index = Math.floor(Math.random() * chars.length);
                let c = chars[index];
                chars = chars.slice(0, index).concat(chars.slice(index + 1));
                let tile = {
                    letter: c,
                    visible: false,
                    matched: false,
                };
                row.push(tile);
            }
        }
        return board;
    }

    render() {
        let board = _.map(this.state.board, (row, i) => {
            let tiles = _.map(row, (tile, j) => {
                return <Tile key={i * this.state.board.length + j} tile={tile}/>
            });
            return <div key={100 + i} className="row">{tiles}</div>
        });

        return <div className="container">{board}</div>;
    }
}

function Tile(props) {
    let tile = props.tile;
    console.log(props);
    return <div key={props.key} className="column">
        {tile.letter}
    </div>;
}

