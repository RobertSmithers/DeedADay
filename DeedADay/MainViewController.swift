//
//  MainViewController.swift
//  DeedADay
//
//  Created by RJ Smithers on 4/21/20.
//  Copyright © 2020 RJ Smithers. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, MMM d"
    return dateFormatter
}()

class MainViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deedLabel: UILabel!
    
    var deedArr: [String] = ["Next time you go to a grocery store,pay for the person in front of you","Compliment someone on their smile","Compliment someone on their outfit","Make a double-batch of something yummy and gift to a neighbor.","Buy a bag of good groceries and donate it to your local food bank or shelter.","Cut fresh wildflowers and bring them to your local nursing home so the residents can enjoy.","Bring your well-behaved dog for a visit at a local nursing home.","Hold the door for people behind you.","Bring someone less fortunate a plant or some fresh flowers.","Make a meal for a friend recovering from surgery or an illness.","Babysit for free – parents will always appreciate a much-needed break.","Put together a basket of treats for someone who has had a death in the family and deliver it after the funeral when they’ll need extra support.","Volunteer for a charity.","Instead of buying gifts for your family, agree to donate the gift in monies to a charity of their choice.","Pass on your unused monthly bus pass to someone in need.","Take your neighbors trash to the curb while you’re taking yours.","When in line at the grocery store,let the person behind you go in front of you.","Pet sit for neighbors going out of town.","Make or order dinner for friends with a newborn baby.","Pay for the person behind you at the drive-thru.","Help someone who looks lost with directions.","Donate blood or volunteer for the American Red Cross.","Donate your used clothes and housewares to charity.","Take a CPR class – you never know when you might need to use it.","Help an elderly person off the bus.","Bring your old magazines to a hospital waiting room to make a visitor’s wait better.","Write a letter or e-mail to a good friend or family member to let them know how much you value them.","Offer to walk a neighbor’s dog once a week.","Help a parent who is struggling to get a stroller down or up the stairs.","Offer an elderly person, a pregnant woman,a physically disabled person – or just someone who looks tired – your seat on the bus.","Keep your city clean by picking up plastic bottles and other trash you see around your neighborhood.","Visit a nursing home to chat with some of the residents.","Smile at everyone you pass on the street.","Pass on your books after you’ve read them for someone else to enjoy.","If you’ve discovered a great little restaurant or store,spread the word.","Let go of an old grudge.","Help wrap gifts during the holidays.","On a random weekend,surprise your loved ones with breakfast in bed.","When you come across a buy one,get one free deal,donate the free product to someone in need.","Compliment a stranger.","Volunteer to do someone’s grocery shopping for them every two weeks.","Leave your server a very generous tip.","Feed parking meters that are about to expire.","Pick up a large bag of cat or dog food to donate to a local animal shelter.","Write a note of appreciation to your mail carrier.","Give a lottery ticket to a stranger","Put together a writing kit with stationery,envelopes and stamps,pen and give to hospital/nursing home.","Put change in candy and vending machines – or tape a couple of dollars to the machine.","Buy a phone card and give to a homeless shelter for them to give to someone.","Take flowers to a hospital ward and give them to someone who hasn’t had any visitors.","Drop a few coins in an area where children play so they can find them.","Let someone merge in front of you during rush hour.","Many small,local nonprofits have “wishlists” of items they are currently looking for or always need. Provide 3 of those items.","Bring baked goods to your local police or fire station to say thank you.","Finish a punch card (for a restaurant,car wash,etc.) and give the “free” one to someone else.","Walk for something that is important to you.","Give a fast food gift card to someone who is homeless.","Put out a bird feeder to feed the birds.","Leave a note or a dollar in a library book for somebody else.","Donate books to the library.","While in a restaurant,pay for the meals at another table.","Weed someone’s garden.","Make arrangements to pay for a stranger’s gas, water, telephone, or electric bill.","Rake someone’s yard.","Go to the dry cleaners. Pay for someone’s dry cleaning.","Create care packages for the homeless.","Pay for movie tickets for a family while at the movie theater.","Stop by a street vendor and give the proprietor a $20.00 bill. Tell the proprietor to give free merchandise to the next several customers until the $20.00 is consumed.","Buy car wash certificates to keep in your car to use through out the year. Each time you go, give the attendant two tickets, one for you, and one for the car behind you.","Knit something for a friend,family member,or a cause.","Attend an event important to your loved one.","Mow a neighbor’s lawn.","Collect coats to donate.","Send a care package to a loved one.","Offer someone a piece of gum.","Make aromatherapy for someone.","Say “bless you” when someone sneezes.","Leave coupons at the grocery store by leaving the coupon next to the product that it is for.","Straighten things up on store shelves while you browse.","Hand out free popsicles on a hot day.","Reuse “thought-for-the-day” calendar pages by adding them to each piece of outgoing mail.","Leave quarters at the laundromat for others to use.","Return shopping carts to their designated area.","Share an inspirational quote.","Leave a thank you note.","Give a balloon to a child.","Read to a child.","Blow bubbles at the park for kids.","Donate your talents.","Call everyone you know and tell them you love them","Cheer someone on.","Offer a ride to someone who cannot drive or does not have a car.","Help someone achieve a goal.","Write encouraging messages on sticky notes and stick them in random places like a car wash, vending machine, etcetera.","Send expired coupons for military to use on base.","Take in someone’s garbage cans.","Say a prayer for someone.","Take crayons and coloring books to a hospital children’s ward.","Put a dollar in the toy section at your local dollar store.","Give stickers out to kids you pass on the street.","Write a note on the sidewalk with chalk and make someone smile.","Collect Box Tops and donate them to a local school.","Buy a 100 Good Deeds bracelet."]
    
    var lastUpdateDay: String = ""
    var notificationTimer = 24 * 60 * 60
    var changeDeed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        LocalNotificationManager.authorizeLocalNotifications(viewController: self)
        LocalNotificationManager.isAuthorized { (authorized) in
            if authorized {
                self.dispatchNewNotificationTimer(self.notificationTimer)
            }
        }
    }
    
    func updateUI() {
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        let usableDate = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        let today = dateFormatter.string(from: usableDate)
        self.dateLabel.text = today
        
//        Needs a database to keep track of date
        if lastUpdateDay == today {
            print("Same Day!")
        } else {
            generateDeed()
            lastUpdateDay = today
        }
    }
    
    func dispatchNewNotificationTimer(_ time: Int) {
        // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        LocalNotificationManager.setCalendarNotification(title: "Deed A Day", subtitle: "", body: "Come check out your daily deed and change the world!", badgeNumber: nil, sound: .default, date: Date().addingTimeInterval(TimeInterval(time)))
    }
    
    func generateDeed() {
        let newDeed = deedArr.randomElement()
        if newDeed == deedLabel.text {
            generateDeed()
        } else {
            deedLabel.text = newDeed
        }
    }
    
    
    
}
