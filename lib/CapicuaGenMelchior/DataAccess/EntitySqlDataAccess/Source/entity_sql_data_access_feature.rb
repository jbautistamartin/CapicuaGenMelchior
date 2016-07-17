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

require_relative '../../../melchior'
require 'active_support/core_ext/object/blank'
require 'uuidtools'

module CapicuaGen::Melchior

  # Característica que lee un archivo o string SQL y convierte las tablas leidas
  # en entidades y lo expone para otras características
  # las características pueden usar las entidades expuestas como clases o interfaces
  class EntitySqlDataAccessFeature < CapicuaGen::Feature

    public

    # Inicializa la característica
    def initialize(values= {})
      super(values) do end

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:entity_sql_table] if self.types.blank?

      @sql_string= []
      @entities  = []

      #Ejecuto configuracion en bloque
      yield self if block_given?
    end


    # Agrego una cadena SQL a las cadenas a analizar
    def add_sql_string(*sql_strings)
      # Reinicio las entidades presentes
      @entities  = []
      # Agrego las cadenas
      @sql_string+= sql_strings
    end

    # Agreo un archivo SQL
    def add_sql_file(*sql_files)
      sql_files.each do |f|
        sql_string= File.open(f).read
        add_sql_string(sql_string)
      end
    end

    # Devuelvo las entidades
    def get_entities

      # Si tengo entidades ya creadas las devuelvo
      @entities unless @entities.blank?

      # Creo un parseador de entidades
      parser   = CapicuaGen::Melchior::SqlTableParse.new
      @entities= parser.parse_string(*@sql_string)

      return @entities

    end


  end

end