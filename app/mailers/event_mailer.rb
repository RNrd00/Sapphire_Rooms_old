class EventMailer < ApplicationMailer
  def send_notification(member, event)
    @group = event[:group]
    @name = event[:name]
    @introduction = event[:introduction]

    @mail = EventMailer.new
    mail(
      from: ENV["MAIL_ADDRESS"],
      to: member.email,
      subject: "New Event Notice!!"
    )
  end

  def self.send_notifications_to_group(event)
    group = event[:group]
    group.customers.each do |member|
      EventMailer.send_notification(member, event).deliver_now
    end
  end
end
