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
                    row: i,
                    col: j,
                    letter: c,
                    state: "hidden", // state is one of: "hidden", "visible", "matched"
                };
                row.push(tile);
            }
        }
        return board;
    }

    // determines if a click at the given index makes a match with a currently-visible tile
    matchMade(rowIdx, colIdx) {
        let tile = this.state.board[rowIdx][colIdx];
        return _.some(this.state.board, (row) => {
            return _.some(row, (currTile) => {
               return currTile.state === "visible" &&
                   !(currTile.row === tile.row && currTile.col === tile.col) &&
                   currTile.letter === tile.letter;
            });
        });
    }

    // generates the next board, after a click at the given indices
    boardAfterClick(rowIdx, colIdx) {
        return _.map(this.state.board, (row) => {
            return _.map(row, (col) => {
                return this.nextTile(col, rowIdx, colIdx);
            });
        });
    }

    // generates the next tile, after a click at the given indices
    nextTile(tile, clickRow, clickCol) {
        let matched = this.matchMade(clickRow, clickCol);
        // this tile is currently visible
        if (tile.state === "visible") {
            return matched ? _.assign({}, tile, {state: "matched"}) : tile;
        } else if (tile.row === clickRow && tile.col === clickCol) { // this is the clicked tile
            let nextState = matched ? "matched" : "visible";
            return _.assign({}, tile, {state: nextState});
        } else {
            return tile;
        }
    }

    // returns the number of tiles visible on the given board
    visibleCount(board) {
        return _.reduce(board,  (sum, row) => {
            return sum + _.reduce(row, (sum, tile) => {
                return sum + (tile.state === "visible" ? 1 : 0);
            }, 0);
        }, 0);
    }

    // flips over all visible tiles
    clearVisible() {
        let board = _.map(this.state.board, (row) => {
            return _.map(row, (tile) => {
               if (tile.state === "visible") {
                   return _.assign({}, tile, {state: "hidden"});
               } else {
                   return tile;
               }
            });
        });
        this.setState(_.assign({}, this.state, {board: board}));
    }

    // handles a click at the given location, changing the state if necessary
    tileClicked(rowIdx, colIdx) {
        let visibleCount = this.visibleCount(this.state.board);
        if (visibleCount >= 2) {
            return;
        }
        let board = this.boardAfterClick(rowIdx, colIdx);
        visibleCount = this.visibleCount(board);
        if (visibleCount === 2) {
            window.setTimeout(this.clearVisible.bind(this), 1000);
        }
        this.setState(_.assign({}, this.state, {board: board, clicks: this.state.clicks + 1}));
    }

    // resets the game and creates a new board
    reset() {
        this.setState({board: this.genBoard(), clicks: 0});
    }

    render() {
        let board = _.map(this.state.board, (row, i) => {
            let tiles = _.map(row, (tile, j) => {
                return <Tile key={i * this.state.board.length + j} tile={tile} clickHandler={() => {
                    this.tileClicked(i, j);
                }
                }/>
            });
            return <div key={100 + i} className="row">{tiles}</div>
        });

        return <div>
            <h1 className="title">Memory Game</h1>
            <div>
                <h2 className="title clicks">Clicks: {this.state.clicks}</h2>
                <Reset clickHandler={this.reset.bind(this)}/>
            </div>
            <div className="container">{board}</div>
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

