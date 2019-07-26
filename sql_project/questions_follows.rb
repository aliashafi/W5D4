require_relative 'users'
require_relative 'replies'
require_relative 'questions'
require_relative 'questions_database'


class QuestionFollows

  attr_accessor 

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def self.followers_for_question_id(question_id)
    question_followers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.fname, users.lname
      FROM
        users
      JOIN question_follows ON users.id = question_follows.user_id
      JOIN questions ON questions.id = question_follows.question_id
      WHERE
        questions.id = ?
    SQL
  end

  def self.most_followed_questions(n)
    question_followers = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.title, COUNT(question_follows.id) AS question_follows
      FROM
        questions
      JOIN question_follows ON questions.id = question_follows.question_id
      GROUP BY
        questions.title HAVING COUNT(question_follows.id)
      ORDER BY 
        question_follows DESC LIMIT ?

    SQL
  end

  def self.followers_questions_for_user_id(user_id)
    question_followers = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.title
      FROM
        questions
      JOIN question_follows ON questions.id = question_follows.question_id
      JOIN users ON users.id = question_follows.user_id
      WHERE
        users.id = ?
    SQL
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end


end

if $PROGRAM_NAME == __FILE__
  question = Users.find_by_id(2)
  p QuestionFollows.followers_questions_for_user_id(2)
end