class Homework
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def all
    sql = "SELECT language, slug, archived FROM user_exercises WHERE user_id = #{user.id} ORDER BY language, slug ASC"
    extract(sql)
  end

  private

  def extract(sql)
    UserExercise.connection.execute(sql).each_with_object(empty_hash) do |row, exercises|
      exercises[row['language']] << { 'slug' => row['slug'], 'state' => row['archived'] == 't' ? 'archived' : 'active' }
    end
  end

  def empty_hash
    Hash.new { |hash, key| hash[key] = [] }
  end
end
