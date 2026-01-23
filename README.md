# Rails_Compliance_System
**Sistema de compliance para a empresa _ISM GOMES DE MATTOS_**


- [Rails\_Compliance\_System](#rails_compliance_system)
  - [Descrição.](#descrição)
  - [Entregáveis.](#entregáveis)
  - [Backend.](#backend)
  - [Front-End.](#front-end)
  - [Arquitetura de Segurança](#arquitetura-de-segurança)
    - [Fluxo de Interações](#fluxo-de-interações)
  - [Matriz de Controle de Acesso (RBAC)](#matriz-de-controle-de-acesso-rbac)
  - [Camadas de Implementação Técnica](#camadas-de-implementação-técnica)
    - [Escopo de Busca (Proteção contra IDOR)](#escopo-de-busca-proteção-contra-idor)
    - [Autorização Atômica](#autorização-atômica)
    - [Filtro de Parâmetros por Perfil (Mass Assignment)](#filtro-de-parâmetros-por-perfil-mass-assignment)
    - [Ofuscação de Identificadores](#ofuscação-de-identificadores)
  - [Protocolo de Validação (QA)](#protocolo-de-validação-qa)
    - [Isolamento de Perfil](#isolamento-de-perfil)
    - [Integridade de Status](#integridade-de-status)
    - [Privacidade de Detalhes](#privacidade-de-detalhes)

## Descrição.
Desenvolver a infraestrutura lógica (Back-end) para o Canal de Denúncias da ISM
Alimentação. O sistema será responsável por receber os dados do front-end existente,
garantir a segurança das informações e disponibilizar um Painel Administrativo para a
gestão das denúncias.

## Entregáveis.


- Recepção de Denúncia: Rota segura para recebimento de dados e
provas/evidências.
- Geração de Protocolo: Criação automática de um código único e anônimo para
acompanhamento do caso.
- Consulta de Status: Endpoint para verificação do andamento via protocolo.
- Interface: Desenvolvimento da interface de input e do Painel Administrativo.
- Segurança : Autenticação e autorização de usuários, conformidade com a LGPD e
proteção contra ataques web comuns.


## Backend.

**Ruby on Rails**

**Postgre SQL**

## Front-End.

**HTML**

**CSS**

**JavaScript**

**Flexbox**

**React**

## Arquitetura de Segurança

O sistema adota o modelo de **Defesa em Profundidade** para garantir a integridade dos dados e o isolamento de informações sensíveis, conforme ilustrado no fluxo de interações abaixo.

---

### Fluxo de Interações

```mermaid
graph TD
    %% Dark Mode High-Contrast Theme
    classDef visitor fill:#38bdf8,stroke:#0ea5e9,color:#000,stroke-width:2px;
    classDef admin fill:#fb7185,stroke:#e11d48,color:#000,stroke-width:2px;
    classDef dilig fill:#4ade80,stroke:#16a34a,color:#000,stroke-width:2px;
    classDef page fill:#1e293b,stroke:#94a3b8,stroke-width:2px,color:#f8fafc;
    classDef logic fill:#334155,stroke:#94a3b8,stroke-dasharray: 5 5,color:#cbd5e1;
    classDef db fill:#0f172a,stroke:#38bdf8,color:#38bdf8,stroke-width:2px;

    subgraph Card [ARQUITETURA DE SEGURANÇA E FLUXO DE DADOS]
        direction TB

        subgraph Usuarios [1. ATORES E PERMISSÕES]
            direction LR
            V((Visitante)):::visitor
            A((Admin)):::admin
            D((Diligencia)):::dilig
        end

        subgraph Interfaces [2. PONTOS DE ACESSO]
            direction LR
            subgraph Portal [Portal Publico]
                NewRelato[Fazer Denuncia]:::page
                TrackRelato[Consultar Protocolo]:::page
            end
            subgraph Painel [Painel Interno]
                Auth{RBAC Gate}:::logic
                Dashboard[Gestao de Reports]:::page
            end
        end

        subgraph Logica [3. REGRAS DE NEGOCIO]
            direction LR
            GenProto[before_validation]:::logic
            NestedAttr[nested_attributes]:::logic
            StatusEnum[enum: status]:::logic
        end

        subgraph Dados [4. CAMADA DE DADOS]
            direction LR
            TableReports[(Table: reports)]:::db
            TableNested[(Entidades Vinculadas)]:::db
        end

        %% VISITOR (Blue)
        V --> NewRelato
        V --> TrackRelato
        NewRelato --> GenProto
        GenProto --> TableReports
        TrackRelato -.-> TableReports

        %% ADMIN (Pink)
        A --> Auth
        Auth -- "admin" --> Dashboard
        Dashboard --> StatusEnum
        StatusEnum --> TableReports
        A --> NewRelato

        %% DILIGENCE (Green)
        D --> Auth
        Auth -- "diligence" --> Dashboard
        Dashboard --> NestedAttr
        NestedAttr --> TableNested
    end

    style Card fill:#0f172a,stroke:#334155,stroke-width:4px,color:#f8fafc
    style Usuarios fill:none,stroke:none
    style Interfaces fill:#1e293b,stroke:#334155
    style Logica fill:#0f172a,stroke:#334155
    style Dados fill:#111827,stroke:#38bdf8

    %% --- Final Corrected Arrow Coloring ---
    %% Visitor: Blue (Indices 0,1,2,3,4)
    linkStyle 0,1,2,3,4 stroke:#38bdf8,stroke-width:3px
    %% Admin: Pink (Indices 5,6,7,8,9)
    linkStyle 5,6,7,8,9 stroke:#fb7185,stroke-width:3px
    %% Diligence: Green (Indices 10,11,12,13)
    linkStyle 10,11,12,13 stroke:#4ade80,stroke-width:3px
```
---

## Matriz de Controle de Acesso (RBAC)

| Perfil     | Acesso Ouvidoria | Acesso Diligência | Visualização (`show`)        | Ações de Escrita              |
|------------|------------------|-------------------|------------------------------|-------------------------------|
| Visitante  | Não              | Não               | Não (apenas status)          | Não                           |
| Diligência | Não              | Sim               | Sim (apenas diligência)      | Sim (apenas diligência)       |
| Admin      | Sim              | Sim               | Sim                          | Sim                           |

## Camadas de Implementação Técnica

### Escopo de Busca (Proteção contra IDOR)

O método `set_authorized_report` restringe a busca no banco de dados com base na sessão ativa:

- **Admin**: acesso total via `Report.all`
- **Analista de Diligência**: acesso limitado a registros onde `razao_social` não é nulo
- **Visitante**: bloqueio total de acesso direto por ID

Tentativas de acesso fora do escopo resultam em erro `ActiveRecord::RecordNotFound`, prevenindo enumeração de registros e exposição indevida de dados.

---

### Autorização Atômica

Ações críticas, incluindo `update_status` e `destroy`, possuem validações de perfil internas ao método.

Isso assegura que a autorização seja verificada no momento da execução, independentemente de verificações de rotas globais ou manipulações de interface.

---

### Filtro de Parâmetros por Perfil (Mass Assignment)

O método `filtered_report_params` implementa permissões dinâmicas de atributos:

- **Gestão (Admin)**: acesso integral aos atributos do modelo
- **Público (Visitante)**: permissão restrita exclusivamente aos campos de entrada do relato

Essa camada impede a modificação de metadados administrativos (como `status`) via injeção de parâmetros no cliente.

---

### Ofuscação de Identificadores

A identificação pública de relatos utiliza protocolos gerados via `SecureRandom`, no formato:

    CD-XXXX-XXXX

O uso de identificadores não sequenciais e de alta entropia elimina o risco de descoberta de registros por força bruta ou predição de IDs incrementais.

---

## Protocolo de Validação (QA)

### Isolamento de Perfil
Validar que Analistas de Diligência recebem erro **404** ao tentar acessar IDs de relatos de Ouvidoria.

### Integridade de Status
Confirmar que envios via formulário público **não alteram** o campo `status` original por interceptação de requisições.

### Privacidade de Detalhes
Garantir que usuários não autenticados sejam redirecionados ao tentar acessar a rota `show` por manipulação direta da URL.




