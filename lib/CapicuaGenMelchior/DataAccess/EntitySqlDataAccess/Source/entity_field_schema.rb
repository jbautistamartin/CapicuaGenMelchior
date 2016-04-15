=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martin, el 6 de enero
del 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso el
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

require_relative '../../../melchior'
require 'active_support/core_ext/object/blank'

module CapicuaGen::Melchior

  # Define una campo de una entidad, puede estar ligado a un campo sql
  class EntityFieldSchema

    attr_accessor :name, :type, :size, :allow_null, :default_value, :primary_key, :sql_type, :identity, :sql_name

    def initialize (values= {})

      @name         = values[:name]
      @sql_name     = values[:sql_name]
      @type         = values[:type]
      @size         = values[:size]
      @allow_null   = false
      @allow_null   = values[:allow_null] if values[:allow_null]
      @default_value= values[:default_value]
      @primary_key  = false
      @allow_null   = values[:allow_null] if values[:allow_null]
      @sql_type     = values[:sql_type]
      @identity     = false
      @identity     = values[:@identity] if values[:identity]

      # Ajusto el tipo
      @type         = @sql_type unless @type

      # correguir_nombre
      fix_name

    end


    protected
    # Ajusta el nombre
    def fix_name
      return if @name
      return unless @sql_name
      @name= @sql_name.clone
      /\[[^\]]+\]\.\[([^\]]+)\]/.match (@sql_name) { @name= $1 }
      @name.gsub!("\"", '')
      @name.gsub!("''", '')
      @name.gsub!(" ", '')
    end

  end

end
