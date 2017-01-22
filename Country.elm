import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import String
import Json.Decode as Decode


main =
  Html.program
    { init = init ""
    , view = view
    , update = update
     , subscriptions = subscriptions
    }



-- MODEL

type alias Model =
  { location : String
    , output : String
  }

init : String -> (Model, Cmd Msg)
init location =
  ( Model location ""
  , Cmd.none
  )



-- UPDATE

type Msg
  = GetCountry String | NewCountryCode (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetCountry location->
      (model, (if String.isEmpty location then Cmd.none else getCountry location))

    NewCountryCode (Ok newUrl) ->
      (Model model.location newUrl, Cmd.none)

    NewCountryCode (Err _) ->
      (Model ""  "Bad Request", Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Enter Location to Check Your Country Code", onInput GetCountry ] []
    , div [] [ text (model.output) ]
    ]
    
    
    
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getCountry : String -> Cmd Msg
getCountry location =
  let
    url =
      "http://api.openweathermap.org/data/2.5/weather?q=" ++ location ++"&appid=dabbe19700759dfe1d05821c3876b9c5"
  in
    Http.send NewCountryCode (Http.get url decodeCountry)


decodeCountry : Decode.Decoder String
decodeCountry =
  Decode.at ["sys", "country"] Decode.string
  
