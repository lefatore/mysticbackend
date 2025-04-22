package main

import (
    "log"
    "os"

    "github.com/pocketbase/pocketbase"
    "github.com/pocketbase/pocketbase/apis"
    "github.com/pocketbase/pocketbase/core"
    "github.com/pocketbase/pocketbase/middlewares"
    "github.com/labstack/echo/v4"
)

func main() {
    app := pocketbase.New()

    // ✅ Inject CORS middleware
    app.OnBeforeServe().Add(func(e *echo.Echo) error {
        e.Use(middlewares.Cors()) // allow all origins by default
        return nil
    })

    app.OnServe().BindFunc(func(se *core.ServeEvent) error {
        se.Router.GET("/{path...}", apis.Static(os.DirFS("./pb_public"), false))
        return se.Next()
    })

    if err := app.Start(); err != nil {
        log.Fatal(err)
    }
}
