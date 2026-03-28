# 💊 DoseCertaPro

O **DoseCertaPro** é um ecossistema de gestão de medicamentos desenvolvido em Swift/SwiftUI. Este projeto foi concebido como um estudo de caso em **Desenvolvimento Mobile Profissional**, aplicando padrões de mercado para garantir escalabilidade, testabilidade e manutenibilidade.

## Objetivo do projeto
Demonstrar a implementação de uma arquitetura modular e desacoplada, utilizando as melhores práticas de desenvolvimento para resolver problemas comuns de fluxo, estado e persistência.

---

## Boas práticas e arquitetura implementadas

O projeto segue rigorosamente os seguintes pilares técnicos:

### 1. Padrão Arquitetural: MVVM-C (Model-View-ViewModel + Coordinator)
A navegação foi extraída das Views para um **Coordinator** centralizado.
* **Desacoplamento:** As Views não conhecem seus destinos, apenas notificam eventos ao Coordinator.
* **NavigationStack:** Uso de `NavigationPath` reativo para gerenciar pilhas de navegação complexas e fluxos de autenticação.

### 2. Injeção de Dependência e Inversão de Controle (DI/IoC)
Foi utilizado um **Dependency Container** para gerenciar o ciclo de vida dos serviços.
* **Protocol-Oriented Programming (POP):** Todas as dependências são baseadas em protocolos, facilitando a substituição de implementações (ex: trocar Firebase por Mock).
* **Interface Segregation:** O Coordinator acessa apenas o que precisa através de protocolos específicos (`ViewControllerFactoryProtocol` e `AppStateProvider`).

### 3. Design Pattern: Factory
Implementou-se o padrão **Abstract Factory** para a criação de instâncias de UI.
* **Responsabilidade Única:** A Factory é o único componente que sabe como instanciar ViewModels e injetar seus serviços, mantendo o Coordinator focado apenas no fluxo.

### 4. Clean Code e SOLID
* **SRP (Single Responsibility Principle):** Divisão clara entre lógica de persistência (Services), lógica de estado (ViewModels) e lógica de fluxo (Coordinator).
* **DRY (Don't Repeat Yourself):** Inicialização centralizada no `dosecertaproApp` para evitar múltiplas instâncias de containers.

### 5. Testes Unitários (XCTest)
O app possui uma suíte de testes que valida o "Core" do sistema sem necessidade de conexão externa.
* **Mocks de Serviço:** Uso de implementações de teste para validar o comportamento dos ViewModels.
* **Validação de Fluxo:** Testes que garantem a integridade da pilha de navegação e estados de autenticação.

---

## Estrutura do projeto
* **Models:** Definições de dados puros (Prescription, Medicine).
* **Views:** Telas em SwiftUI focadas apenas em renderização e input.
* **ViewModels:** Motores de estado que processam regras de negócio.
* **Coordinator:** Orquestrador de rotas e modais.
* **Core:** Camada de DI, Protocols e Factory.

---

## Tecnologias
* **SwiftUI** + **Combine**
* **Firebase** (Firestore & Auth)
* **XCTest Framework**

---
*Este é um projeto de portfólio focado em demonstrar competência técnica em arquitetura iOS.*
