## Gravitee api management Ansible Role

### Global description

* Wrapper for Gravitee API endpoints to help create, update and remove APIs.

### Requirements and dependencies

* Gravitee ansible module : No need to incude youself into your project, this role embeds the module.
* Python 2.7 or 3.5
* Ansible >=2.4

To use directly the module or extend it :
https://github.com/gravitee-io-community/ansible-module

Official documentation about Gravitee.io APIM Rest api : https://docs.gravitee.io/apim/api/

### Function

* Manage Oauth2 and basic authentication
* Allow creation, update, start, stop and remove API.
* Compliants with Gravitee APIM REST api, it takes json content as arguments.

Note you can use directly the ansible module in roles declared after this role.

### Configuration

##### Default role vars (overridable):
* `gravitee_api_auth_method`:
    * Auth method
    * Default value : `basic`
    * Values accepted : `basic`, `oauth2`
* `gravitee_api_state`:
    * Set API state
    * Default value : `started`
    * Values accepted : `present`, `started`, `absent`, `stopped`
* `gravitee_api_visibility`:
    * Set API visibility
    * Default value : `PRIVATE`
    * Values accepted : `PRIVATE`, `PUBLIC`
* `gravitee_api_transfer_ownership`:
    * Transfer ownership. Usefull if you use a authenticated user different of the real api owner.
    * Default value : `[]`
* `gravitee_api_config`:
    * Api config content
    * Default value : `{}`
* `gravitee_api_pages`:
    * Api documentation pages
    * Default value : `[]`
* `gravitee_api_plans`:
    * API Plans
    * Default value : `[]

##### required vars:

Commons:

* `gravitee_api_url`:
    * Set API visibility
    * Default value : `PRIVATE`
    * Values accepted : `PRIVATE`, `PUBLIC`

For basic method :

* `gravitee_api_user`:
    * Auth method
    * Default value : `basic`
    * Values accepted : `basic`, `oauth2`
* `gravitee_api_password`:
    * Set API state
    * Default value : `started`
    * Values accepted : `present`, `started`, `absent`, `stopped`

For Auth2 method :

* `gravitee_api_auth_url`:
    * Url for auth endpoint
    * Default value : `None`
* `gravitee_api_auth_resource_id`:
    * Authentication resource name configured into Gravitee APIM
    * Default value : `None`
* `gravitee_api_client_id`:
    * Oauth2 client id
    * Default value : `None`
* `gravitee_api_client_pwd`:
    * Oauth2 client pwd. Can be empty
    * Default value : ``
* `gravitee_api_oauth2_user`:
    * Oauth2 user
    * Default value : `None`
* `gravitee_api_oauth2_pwd`:
    * Oauth2 user pwd
    * Default value : `None`

##### Facts :

When Api is created, the var `api_id` is available.

### Example

#### Playbook

For Basic authent :

```yaml
---
- hosts: localhost
  connection: local
  hosts: localhost
  vars:
    gravitee_api_url: https://manage-api.foo.com
    gravitee_api_user: user
    gravitee_api_password: pwd
    gravitee_api_visibility: PUBLIC
  tasks:
  # Create the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_transfer_ownership:
          user: admin
          owner_role: OWNER
        gravitee_api_config: "{{ lookup('template', playbook_dir + '/resources/create.json') }}"
        gravitee_api_pages:
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"
        gravitee_api_plans:
          - "{{ lookup('template', playbook_dir + '/resources/plan-keyless.json') }}"

  # Update the documentation of the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_id: "{{api_id}}"
        gravitee_api_pages:
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"

  # Remove the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_state: absent
        gravitee_api_id: "{{api_id}}"
 ```

For oauth2 authent :

```yaml
---
- name: Api management with gravitee gateway ansible module
  connection: local
  hosts: localhost
  vars:
    gravitee_api_auth_url: https://sso.foo.com/auth/realms/developer_community/protocol/openid-connect/token
    gravitee_api_url: https://manage-api.foo.com
    gravitee_api_client_id: ansible
    gravitee_api_client_pwd: ""
    gravitee_api_oauth2_user: user
    gravitee_api_oauth2_pwd: "pwd"
    gravitee_api_auth_method: "oauth2"
    gravitee_api_auth_resource_id: keycloak_cluster
  tasks:
  # Create the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_visibility: PUBLIC
        gravitee_api_config: "{{ lookup('template', playbook_dir + '/resources/create.json') }}"
        gravitee_api_pages:
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"
        gravitee_api_plans:
          - "{{ lookup('template', playbook_dir + '/resources/plan-keyless.json') }}"

  # Update the documentation of the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_visibility: PUBLIC
        gravitee_api_id: "{{api_id}}"
        gravitee_api_pages:
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"
          - "{{ lookup('template', playbook_dir + '/resources/page-swagger.json') }}"

  # Remove the API
    - include_role: name="ansible-gravitee-apim"
      vars:
        gravitee_api_state: absent
        gravitee_api_id: "{{api_id}}"
 ```