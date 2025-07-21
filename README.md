<p align="center">
  <img src="content/app_logo.png" alt="Logomarca" width="300">
</p>

![Flutter](https://img.shields.io/badge/Flutter-3.32.4-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue?logo=dart)

---

## 📃 Descrição

O **Loca Student** é um aplicativo pensado para a comunidade estudantil. Ele foi desenvolvido para aproximar **estudantes** e **repúblicas**, permitindo pesquisar acomodações, reservar vagas e gerenciar reservas já feitas. Além de um design moderno, o app prioriza **simplicidade**, garantindo uma experiência agradável.

---

## 💻 Tecnologias Utilizadas

- **Parse Server**: Backend para autenticação, armazenamento de dados e gerenciamento das reservas.
- **BLoC**: Gerenciamento de estado escalável.

---

## 🛎️ Funcionalidades

O aplicativo **Loca Student** oferece as seguintes funcionalidades:

✅ **Exploração de Repúblicas**  
Pesquise por cidade e visualize detalhes completos como endereço, valor do aluguel, vagas disponíveis e contatos.

✅ **Gerenciamento de Reservas**  
Acompanhe suas reservas **pendentes** ou **aceitas** diretamente no app, podendo também cancelar ou reativar quando necessário.

---

## 📡 Integração com Backend

- **Autenticação**: Login e registro de usuários (estudantes e repúblicas).
- **Banco de Dados (Parse)**:  
  - Tabela `Student`: informações de cada estudante.  
  - Tabela `Republic`: informações de cada república.  
  - Tabela `Reservations`: reservas criadas e seus status.  
  - Tabela `InterestedStudents`: controle de interesse dos estudantes e seus status.
  - Tabela `Tenants`: lista de estudantes aceitos como inquilinos na república.
 
---

## 🎨 Telas do Aplicativo

- **Login**  
  Tela de autenticação onde o usuário (estudante ou república) informa email e senha para entrar no app.

- **Cadastro de Usuário**  
  Formulário para registrar novo estudante ou república, com campos específicos para cada tipo.

- **Página Inicial do Estudante**  
  Tela com duas abas:  
  - Lista filtrada de repúblicas disponíveis para reserva.  
  - Visualização das reservas feitas pelo estudante, com status e opções de gerenciamento.

- **Página Inicial da República**  
  Tela com duas abas:  
  - Lista dos estudantes interessados em vagas na república.  
  - Lista dos inquilinos (estudantes aceitos).

- **Perfil**  
  Exibe os dados do usuário logado, permitindo visualizar e editar informações pessoais. Também possibilita logout.

- **Sobre**  
  Apresenta informações sobre o aplicativo, funcionalidades, versão e uma breve descrição do projeto.

---

## 🎥 Apresentação

Vídeo que apresenta o funcionamento do aplicativo e explica como cada requisito foi implementado no código:

[Assistir](https://youtu.be/r2aBu6VeumI)

---

## 🛠️ Ambiente de Desenvolvimento

- **IDE:** Visual Studio Code  
- **MBaaS:** Back4App

---

## 📦 Instalação

### 🔧 Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado  
- Dispositivo físico ou emulador configurado

### ▶️ Rodando o projeto
```bash
git clone https://github.com/{seu_usuario}/loca_student.git
cd loca_student
flutter pub get
flutter run
