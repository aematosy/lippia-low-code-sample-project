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

  @CreateProject
  Scenario: Crear un proyecto para un workspace especifico
    Given call Clocky.feature@ListWorkspace
    And base url env.base_url_clockify
    And endpoint /v1/workspaces/{{ideWorkspace}}/projects
    And set value "Project9" of key name in body addProject.json
    When execute method POST
    Then the status code should be 201

  @CreateProject @Listar_Proyectos_400
  Scenario: Listar los Proyectos No Encontrado
    Given base url https://api.clockify.me/api
    And   endpoint /v1/workspaces/652ea6cb12942c739a/projects
    And header Content-Type = application/json
    And header Accept = */*
    And header x-api-key = Y2U4YzdiMDgtMDE1Yi00NDQyLWIwMzAtNDA4MGI0NDI1M2I3
    When  execute method GET
    Then  the status code should be 404