// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
//import "../css/App.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom';

import "./socket"
import { ch_join, ch_push, ch_reset } from "./socket";



function App(_) {
    const win = "win"
    const lose = "lose"
    const guessing = "guessing"
    const maxGuesses = 8;

    let [state, setState] = useState({
        guesses: [],
        cowbull: [],
        feedback: "",
        gamestate: guessing
    }
    )

    useEffect(() => {
        ch_join(setState);
    }, []);

    function makeGuess() {
        let guess = text.split("")
        let i = 0
        while (i < guess.length) {
            guess[i] = parseInt(guess[i], 10)
            i ++
        }

        setText("")

        ch_push(guess);
    }

    // TODO: Start up here tomorrow

    let [text, setText] = useState("")

    // Based on updateText function from hangman in class
    function updateText(ev) {
        if (!isNaN(ev.target.value) && ev.target.value.length < 5) {
            setText(ev.target.value)
        }
    }

    // Based on keyPress function from hangman in class
    function keyPress(ev) {
        if (ev.key === "Enter") {
            makeGuess()
        }
    }

    function isAllUnique(guess) {
        let splitguess = guess.split('')
        let i = 0;
        let j = 0;
        for (i = 0; i < splitguess.length - 1; i++) {
            for (j = i + 1; j < splitguess.length; j++) {
                if (splitguess[i] === splitguess[j]) {
                    return false
                }
            }
        }
        return true
    }

    function resetGame() {
        setText("")
        ch_reset()
    }

    function RenderGuesses() {
        let guesses = state.guesses
        let cowsbulls = state.cowbull

        let tablehead = 
                <tr>
                    <th className="tableheader">Guess</th>
                    <th className="tableheader">Bulls</th>
                    <th className="tableheader">Cows</th>
                </tr>

        let tablerows = []
        let i = 0;

        for (i = 0; i < maxGuesses; i++) {
            if (i < guesses.length) {
                let guess = guesses[i]
                let [cows, bulls] = cowsbulls[i]
                tablerows.unshift(
                    <tr>
                        <td className="guess">{guess}</td>
                        <td className="bulls">{bulls}</td>
                        <td className="cows">{cows}</td>
                    </tr>
                )
            } else {
                tablerows.push(
                    <tr>
                        <td className="guess"></td>
                        <td className="bulls"></td>
                        <td className="cows"></td>
                    </tr>
                )
            }
        }

        return (<table className="guesstable">
            <thead>{tablehead}</thead>
            <tbody>{tablerows}</tbody>
            </table>
        )
    }

    function ResetButton() {
        return <button onClick={resetGame}> Reset </button>
    }

    function GuessButton() {
        return <button onClick={makeGuess}> Guess </button>
    }

    function RenderFeedback() {
        return <p className="feedback">{state.feedback}</p>
    }

    let body = <p>Gamestate unknown</p>;


    if (state.gamestate === lose) {
        body = (
            <div>
                <h1>You lose!</h1>
                <ResetButton />
                <RenderGuesses />
            </div>
        )
    } else if (state.gamestate === win) {
        let isPlural = 'es'
        if (state.guesses.length <= 1) {
            isPlural = ''
        }
        body = (
            <div>
                <h1>You won in {state.guesses.length} guess{isPlural}!</h1>
                <ResetButton />
                <RenderGuesses />
            </div>
        )
    } else if (state.gamestate === guessing) {
        body = (
            <div>
                <h1>4 digits</h1>
                <p>
                    <input type="text" value={text} onChange={updateText} onKeyPress={keyPress} />
                    <GuessButton />
                </p>
                <RenderFeedback />
                <RenderGuesses />
                <ResetButton />
            </div>
        )
    }

    return (
        <div className="App">
            {body}
        </div>
    );
}

ReactDOM.render(
    <React.StrictMode>
        <App />
    </React.StrictMode>,
    document.getElementById('root')
);



export default App