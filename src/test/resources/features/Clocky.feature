Feature: Clocky

  Background: headers
    Given header Content-Type = application/json
    And header Accept = */*
    And header x-api-key = MDkxYzFlYmEtNGQ4Ni00ZDA2LTlhYmYtMjJkNjgzYzVmMWUx

  @ListWorkspace
  Scenario: Listar Espacios de trabajo
    Given base url https://api.clockify.me/api
    Given endpoint /v1/workspaces
    When execute method GET
    Then the status code should be 200
    * define ideWorkspace = $.[0].id

  @CrearProyecto
  Scenario: Crear un proyecto para un workspace especifico
    Given call Clocky.feature@ListWorkspace
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects
    And set value "Project9" of key name in body addProject.json
    When execute method POST
    Then the status code should be 201
    * define projectID = $.id

  @ListarProyectos
  Scenario: Listar Proyectos
    Given call Clockify.feature@ListWorkspace
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects
    When execute method GET
    Then the status code should be 200
    * define projectID = $.[0].id

  @ConsultarProyectoPorID
  Scenario: Consultar proyectos por ID
    Given call Clockify.feature@ListarProyectos
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects/{{projectID}}
    When execute method GET
    Then the status code should be 200

  @EditarProyectoEstimate
  Scenario: Editar proyecto estimate
    Given call Clockify.feature@ListarProyectos
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects/{{projectID}}/estimate
    And body updateEstimate.json
    When execute method PATCH
    Then the status code should be 200
    And response should be budgetEstimate.active = true

  @ListarClientes
  Scenario: Listar clientes de un espacio de trabajo
    Given call Clockify.feature@ListWorkspace
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/clients
    When execute method GET
    Then the status code should be 200

  @ListarProyectos
  Scenario: Listar Proyectos
    Given call Clockify.feature@ListWorkspace
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects
    When execute method GET
    Then the status code should be 200
    * define idproyecto = $.[0].id

  @CreateProject @Listar_Proyectos_400
  Scenario: Listar los Proyectos No Encontrado
    Given call Clocky.feature@ListWorkspace
    And base url https://api.clockify.me/api
    And   endpoint /v1/workspaces/652ea6cb12942c739a/projects
    And header Content-Type = application/json
    When  execute method GET
    Then  the status code should be 404

  @ConsultarProyecto_error
  Scenario: Error al consultar proyectos
    Given call Clockify.feature@ListarProyectos
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/projects/{{ideWorkspace}}
    When execute method GET
    Then the status code should be 404
    And response should be error = Not Found
