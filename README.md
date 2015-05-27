# random_fulcrum_point

## Setup

Set the following environment variables

- `FULCRUM_API_KEY`
  - Your API key for your Fulcrum org, where your form lives.
- `FULCRUM_FORM_ID`
  - Fulcrum ID of the form you want to create records in.
- `FULCRUM_FIELD_ID`,
  - The Fulcrum ID of the text field we can put data in.
- `FULCRUM_TOGGLE_RECORD_ID`
  - Fulcrum ID for the record who has a yes/no field which we can use as a
    toggle for whether we should actually create a random record.
- `FULCRUM_TOGGLE_FIELD_ID`
  - Fulcrum ID for the yes/no field, whose value in the record above we use to
    find decide whether we should actually create a random record.

Note: In production, these can be set through Heroku. Locally, we can put them
in `.env`.

## Running

`bundle exec foreman start`

Optionally specify the port:

`PORT=9000 bundle exec foreman start`

## Testing Locally

### Create one random point

To hit the URL locally, you can use CURL:

`curl -d '' http://localhost:3000/`

Note: If you change the port when starting the server, you'll need to change
it here.

### Create 100 random points

To hit the URL repeatedly, you can start up IRB and run the following:

```
100.times { `curl -d '' http://localhost:3000/` }
```

