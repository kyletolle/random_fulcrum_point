# random_fulcrum_point

## Installing

`bundle install`

## Setup

Set the following environment variables

- `FULCRUM_API_URL`
  - Defaults to `https://api.fulcrumapp.com`, but you can override it to use
    locally with something like `http://localhost:3000`.
- `FULCRUM_API_KEY`
  - Your API key for your Fulcrum org, where your form lives.
- `FULCRUM_FORM_ID`
  - Fulcrum ID of the form you want to create records in.
- `FULCRUM_FIELD_ID`,
  - The Fulcrum ID of the text field we can put data in.
- `BBOX`
  - Optional. The bounding box of the area where the random points will be
    restricted to. Format is `minx,miny,maxx,maxy`. Defaults to an area around
    New York City.
- `FULCRUM_ALWAYS_CREATE_RECORD`
  - Optional. Whether we should always create a record, and not even check the
    toggle record. If this is `true`, then you don't even need to specify the
    next two environment variables. Otherwise, it'll use the result from the
    following record to determine wheter it should create the record.
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

