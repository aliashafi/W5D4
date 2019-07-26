require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'
require_relative 'questions_follows'
class Questions
  attr_accessor :title, :body, :user_id, :id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_id(id)
     question = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Questions.new(question.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    Users.find_by_id(@user_id)
  end

  def replies
    Replies.find_by_questions(@title)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end
end

if $PROGRAM_NAME == __FILE__
  question = Questions.find_by_id(2)
  p question.followers
end