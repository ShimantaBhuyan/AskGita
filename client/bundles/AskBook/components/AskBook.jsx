import React, { useState } from 'react';
import style from './AskBook.module.css';
import LordKrishnaImage from "images/lord_krishna.jpg";

const AskBook = () => {
  const [question, setQuestion] = useState("");
  const [answer, setAnswer] = useState("");
  const [isGenerating, setIsGenerating] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsGenerating(true);
    console.log(question);
    const response = await fetch('/ask', {
        method: 'POST',
        headers: {
        'Content-Type': 'application/json'
        },
    body: JSON.stringify({ question: `"${question}"` })
    });
    const data = await response.json();
    console.log(data);
    setIsGenerating(false);
    setAnswer(data.response);
  }

  return (
    <div className={style.container}>
      <h1 className={style.header}>Unlock mysteries of life from Krishna</h1>
      <img src={LordKrishnaImage} className={style.headerImage}/>
      <div className={style.content}>
        <form onSubmit={handleSubmit} className={style.form}>
            <label htmlFor="question">
            Radhe Radhe! What can Krishna help you with today?          
            </label>
            <input name='question' type="text" id="question" value={question} onChange={(e) => setQuestion(e.target.value)} className={style.question} />
            <button type="submit" className={style.submitButton} disabled={isGenerating}>Enlighten Me</button>
        </form>
        {isGenerating ? (
            <div className={style.ripple}>
            <div></div>
            <div></div>
        </div>
        ): null}
        {answer ? <div className={`${style.answer} ${isGenerating && style.blurredAnswer}`}>{answer}</div> : null}
      </div>
    </div>
  );
};

export default AskBook;
