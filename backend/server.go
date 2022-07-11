package main

import (
	"backend/configs"
	"backend/model"
	"database/sql"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
)

func healthz(c echo.Context) error {
	return c.String(http.StatusOK, "O pai ta on!")
}

func getCourses(c echo.Context) error {
	stmt := `
		SELECT
			id_disciplina,
			nome,
			sigla
		FROM
			disciplina;
	`

	courses := []model.Course{}

	db, err := sql.Open(configs.GetDBType(), configs.GetPostgresConnString())
	CheckError(err)

	rows, e := db.Query(stmt)
	CheckError(e)

	for rows.Next() {
		var course model.Course

		if err := rows.Scan(&course.Id_disciplina, &course.Nome, &course.Sigla); err != nil {
			log.Fatal(err)
		}
		courses = append(courses, course)
	}

	return c.JSON(http.StatusOK, courses)
}

func CheckError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	e := echo.New()

	e.GET("/healthz", healthz)
	e.GET("/courses", getCourses)

	e.Start(":1323")

}
