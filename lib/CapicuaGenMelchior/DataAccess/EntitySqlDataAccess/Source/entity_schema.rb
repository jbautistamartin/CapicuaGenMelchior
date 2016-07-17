=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martín, el 6 de enero
de 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso al
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

module CapicuaGen::Melchior


# Clase para definir la estructura de una entidad, puede tener propiedades a su vez
  class EntitySchema

    attr_accessor :name, :fields, :sql_name

    def initialize (values= {})
      @name  = values[:name]
      @fields= values[:fields]
      @fields= [] unless @fields

      @sql_name= values[:sql_name]

      # correguir_nombre
      fix_name
    end

    # Deuelve los campos primarios
    def primary_fields
      return @fields.select { |field| field.primary_key }
    end

    def non_primary_fields
      return @fields - primary_fields
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