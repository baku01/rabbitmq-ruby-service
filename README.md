# 🐇 RabbitMQ Service

Este projeto implementa um serviço básico de mensageria utilizando RabbitMQ em Ruby. Ele permite enviar e receber mensagens de maneira assíncrona através do protocolo AMQP (Advanced Message Queuing Protocol).

## 📋 Requisitos

- Ruby
- RabbitMQ
- Gem `bunny` para comunicação com RabbitMQ

## 🛠️ Instalação

Primeiro, certifique-se de ter o Ruby instalado em seu sistema. Você pode instalar a gem `bunny` executando o seguinte comando:

```sh
gem install bunny
```

Certifique-se de que o RabbitMQ está instalado e rodando na sua máquina. Para instruções de instalação, visite [RabbitMQ](https://www.rabbitmq.com/download.html).

## 🚀 Uso

A classe `RabbitMQService` encapsula a lógica para enviar e receber mensagens usando RabbitMQ.

### 🔧 Inicialização

A inicialização da conexão e do canal é feita no construtor da classe:

```ruby
class RabbitMQService
  def initialize
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start

    @channel = @connection.create_channel
    @queue = @channel.queue("/", exclusive: true)
    @logger = Logger.new($stdout)
  end
end
```

### 📤 Enviando Mensagens

Para enviar uma mensagem, utilize o método `send_message`. Este método publica a mensagem no canal padrão do RabbitMQ:

```ruby
def send_message(payload)
  @channel.default_exchange.publish(payload, routing_key: @queue.name)
  @logger.info("[x] Mensagem enviada com sucesso!")
end
```

### 📥 Recebendo Mensagens

Para receber mensagens, utilize o método `receive_message`. Este método inscreve-se na fila e processa as mensagens recebidas:

```ruby
def receive_message
  @logger.info("[x] Ouvindo mensagens")
  @queue.subscribe(block: false) do |_info, _properties, body|
    @logger.info("[x] Recebido '#{body}'")
  end
end
```

### ❌ Fechando a Conexão

Para fechar a conexão com o RabbitMQ, utilize o método `close_connection`:

```ruby
def close_connection
  @connection.close
end
```

### 💡 Exemplo de Uso

Abaixo um exemplo de uso da classe `RabbitMQService`:

```ruby
# Exemplo de uso:
service = RabbitMQService.new
service.send_message('Hello, RabbitMQ!')
service.receive_message
sleep 1 # Mantém o script rodando para receber mensagens
service.close_connection
```

Este exemplo inicializa o serviço, envia uma mensagem, aguarda para receber mensagens e então fecha a conexão.


