# BEHAVER

## Abstract

BeHaver is my final project for General Assembly's WDI remote program. I drew on my background in Behaviorism to develop a positive reinforcement application. I used the JavaScript framework React for the front end, Ruby on Rails for the back end, and a Postgres database.

The app is hosted on Heroku here: https://behaver-app.herokuapp.com/

Front and Backend git repositories can be found here:
  Front: https://github.com/lornitzoa/behaver_app
  Back: https://github.com/lornitzoa/behaver_api

## Methodology

I started this project by working out some basic wireframes for what I wanted it to look like. I then worked on outlining the basic logic needs to achieve the functional goals. In this, I knew that I had to prioritize my functionality goals and started with the highest priority points to ensure I would have the minimum requirements complete in time for submission. I started with basic authorization routing and UI pieces. Once I had the minimum authorization component goals working, I moved on to developing the databases, routes and UIs for adding and managing the primary data components of tasks, behaviors and reinforcements. I did minimal styling until the very end to ensure I got as much functionality covered as possible. Since this app would be intended to use with children I wanted to keep a very simple design that was easy to read.

## Struggles, Wins and New Skills

### Backend: Ruby on Rails

This project required some intricate data calls that challenged me to learn more about and become more comfortable with relational data and joining tables. I spent many hours debugging and working to understand the principles of Ruby on Rails. I sometimes found that minor changes would totally altered the syntax required for routing. For example, I put some Route definitions into a resource collection, which altered the original delete route I had moved into it and found I needed to use 'destroy' instead. I was not able to find an answer as to why this was the case, but it is something I am aware of and will be prepared to consider in the future.

While I learned a lot about using Ruby on Rails, am more comfortable with it, and am excited to continue developing my skills with it, there are 2 specific skills I learned while working on this project.

First, I wanted to be able to track data over time which mean that I need a table that recorded specific data for each date. I didn't want to create a table that had all dates from now until forever in it with blank fields for future data. Instead I learned to write a task in Ruby and then set up Heroku to schedule those tasks every night just after midnight. I wrote tasks to create entries for the new day's data as well as reset task assignments and available reinforcers, or 'cashins'.

Second, I wanted a user to be able to assign a regular task, but again, didn't want to have a table that just repeated the task. Instead, I specified frequency parameters a user could choose and then wrote parameters for returning tasks each day that met the parameters for that day. For example, I gave the user a choice of Daily, Weekdays, and Weekends. I started simple to keep my logic needs manageable. Then when a call was made for assigned tasks for 'today' only tasks that met today's criteria would be returned. If I wanted to extend the variability of the frequency patterns I would do more research to clean up my logic for this, since the way I have it written now would quickly get over complicated.

## Frontend: React

I decided to use React as the front end framework for this project because I wanted to get more experience with it and get more comfortable with its principles. I definitely want to do some reorganization of my components and try to simplify things. There are places where I am inconsistent in how I call similar components, concepts I want to get more comfortable with, and places where the code could be more concise.

Using Axios I was able to refine my fetch requests to four basic routes and then use a filter method when I wanted to send specific data to a component. I do want to learn more about best practices for making data calls, as I do not think this app is very well optimized. It is constantly updating and calling back data from the database. I chose not to focus too much on optimization with this project as I wanted to focus more on getting the functionality working.

One thing I struggled with is understanding when and why data is passed and made available to components as it is passed in. It was not always clear to me why some data was rendering and other data was not. Some of this was related to the performance issues of having a high volume of data calls on load, I found my Rails server would freeze and I would have to force quit it. This improved after moving some calls to other components, but it was still sometimes an issue. I am not sure if this is a hardware issue, an issue with Axios, or something I don't understand about best practices for data calls.

I was able to learn a little D3.js to implement a pie chart for task completion. I wanted to put together charts to track daily data, but did not end up having time to get to this piece.

On the last day I decided to incorporate React Router into my application. I was able to get the main pages and dashboard set up with routing, but there is still a lot I need to work on as I don't feel like the basic principles of it has clicked for me. I need to start a project with Router framing as I think some of my confusion is due to trying to incorporate routing over an existing framework. I know this is good practice, though, as I am sure this won't be the last time I have to overlay a new framework over a pre-existing one.

## Continued Development  

There are a lot of pieces that I was not able to get to with this application given the allotted time, and it is my intention to continue working on this application.

I had started with the intention of getting role based authentication working, but as I found that pursuing this was eating a lot of my time I decided to move on and come back to it if I had the time. I would like parents to have full control of all elements, assign secondaries who can add points and approve task completion, and then children would only be able to view their dashboard and use points for cashins.

I want to use a lot more charts using D3.js for data tracking.

I want to make the UI experience cleaner, reorganize components and improve the React Router implementation.

## Resources

- Rails authorization with roles:
  - https://medium.com/dailyjs/managing-user-permissions-in-your-react-app-a93a94ff9b40
  - https://www.rubydoc.info/gems/access-granted/1.3.1#Installation


- React Authorization:
  - https://hptechblogs.com/using-json-web-token-react/


- React Routing:
  - https://www.youtube.com/watch?v=lLuhRccWN-g
  - https://reacttraining.com/react-router/web/example/auth-workflow
  - https://blog.bitsrc.io/must-know-concepts-of-react-router-fb9c8cc3c12
  - https://devhints.io/react-router


- Pin Input: https://www.npmjs.com/package/react-pin-input


- axios routing:
  - https://code.tutsplus.com/tutorials/introduction-to-api-calls-with-react-and-axios--cms-21027
  - https://www.npmjs.com/package/axios#axiosposturl-data-config


- SQL task recurrence:  https://www.vertabelo.com/blog/technical-articles/again-and-again-managing-recurring-events-in-a-data-model

- Ruby Dates:
  - https://ruby-doc.org/stdlib-2.1.9/libdoc/date/rdoc/Date.html#method-i-wday


- D3.js Pie Charts:
    - Huntington, Mathew. D3.js Quick Start Guide. Birmingham, Packt Publishing, 2018
    - https://medium.com/codenoobs/simple-d3-pie-chart-in-react-eb4237999553
    - https://www.npmjs.com/package/d3
