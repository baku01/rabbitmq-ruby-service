# frozen_string_literal: true

require 'bunny'
require 'logger'

class RabbitMQService
  def initialize
    @connection = Bunny.new(hostname: 'localhost')
    @connection.start

    @channel = @connection.create_channel
    @queue = @channel.queue("/", exclusive: true)
    @logger = Logger.new($stdout)
  end

  def send_message(payload)
    @channel.default_exchange.publish(payload, routing_key: @queue.name)
    @logger.info("[x] Mensagem enviada com sucesso!")
  end

  def receive_message
    @logger.info("[x] Ouvindo mensagens")
    @queue.subscribe(block: false) do |_info, _properties, body|
      @logger.info("[x] Recebido '#{body}'")
    end
  end

  def close_connection
    @connection.close
  end

end

# Exemplo de uso:
 service = RabbitMQService.new
 service.send_message('Hello, RabbitMQ!')
 service.receive_message
 sleep 1 # Mantém o script rodando para receber mensagens
 service.close_connection
