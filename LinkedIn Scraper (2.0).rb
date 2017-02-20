version_number = "2.0"

# Requirements
require 'watir'
# require 'headless'
require 'dotenv'
require 'fileutils'
require 'csv'

# Load .env
# Must be on same level of the directory as the .env
Dir.glob("/**/.env") do |file|
    Dotenv.load(File.expand_path(file))
end

# Start a new instance of Chrome
$browser = Watir::Browser.new :chrome

# VARIABLES
# Cosmetic
$newline = "\n" # creates new line for readability
$home_path = ""
$pagination_page_number = 20

# Logic
initialPage = "www.linkedin.com"
# Consumer Electronics | Apparel & Fashion | Cosmetics | Consumer Services
# $searchPage = "https://www.linkedin.com/vsearch/c?orig=FCTD&rsid=2154172441485719207287&trk=vsrp_companies_sel&trkInfo=VSRPsearchId%3A2154172441485719095891,VSRPcmpt%3Atrans_nav&f_CCR=us%3A84,us%3A64,us%3A31,us%3A42,us%3A724&f_I=24&openFacets=N,CCR,JO,I,CS&f_CS=C,D,E"
$searchPage = "https://www.linkedin.com/vsearch/c?orig=FCTD&rsid=2154172441486247469811&trk=vsrp_companies_sel&trkInfo=VSRPsearchId%3A2154172441485719095891,VSRPcmpt%3Atrans_nav&f_CCR=us%3A84,us%3A64,us%3A31,us%3A42,us%3A724&f_I=24&f_CS=C,D,E&openFacets=N,CCR,JO,I,CS&page_num=#{$pagination_page_number + 1}"
# $searchPage = "https://www.linkedin.com/vsearch/c?orig=FCTD&rsid=2154172441485719327677&trk=vsrp_companies_sel&trkInfo=VSRPsearchId%3A2154172441485719095891,VSRPcmpt%3Atrans_nav&f_CCR=us%3A84,us%3A64,us%3A31,us%3A42,us%3A724&f_I=19&openFacets=N,CCR,JO,I,CS&f_CS=C,D,E"
# $searchPage = "https://www.linkedin.com/vsearch/c?orig=FCTD&rsid=2154172441485719367271&trk=vsrp_companies_sel&trkInfo=VSRPsearchId%3A2154172441485719095891,VSRPcmpt%3Atrans_nav&f_CCR=us%3A84,us%3A64,us%3A31,us%3A42,us%3A724&f_I=18&openFacets=N,CCR,JO,I,CS&f_CS=C,D,E"
# $searchPage = "https://www.linkedin.com/vsearch/c?orig=FCTD&rsid=2154172441485719918350&trk=vsrp_companies_sel&trkInfo=VSRPsearchId%3A2154172441485719095891,VSRPcmpt%3Atrans_nav&f_CCR=us%3A84,us%3A64,us%3A31,us%3A42,us%3A724&f_I=91&openFacets=N,CCR,JO,I,CS&f_CS=C,D,E"

$count = 0
time = Time.new
month = time.month
day = time.day
year = time.year

company_name = ''
website = ''
location = ''
address = ''
number_of_employees = ''
$head_of_customer_service_name = []
$head_of_customer_service_title = []
$head_of_customer_service_linkedin = []
type_of_company = ''

### FUNCTIONS ###

# Current Page Getter Function
def CurrentPage

    puts "I'm now on #{$browser.url}"
    puts $newline

end

def Screenshot

    $path = "#{$home_path}/LinkedIn/screenshots/(#{$count}) capture.jpg"
    return $browser.screenshot.save($path), $count += 1

end

# Close Browser at End of Process
def Close

    # Close browser
    $browser.close

end

# Email Log In
def EmailLogIn

    field_names = ['session_key', 'session_password']

    field_names.each_with_index do |field, index|
        
        # Sets username and password
        $browser.text_field(:name => field_names[index]).set($emailCredentials[index])

        # Prints username and then password
        puts "I typed #{$browser.text_field(:name => field_names[index]).value} in the input box."

    end

    sleep(2)

    # Screenshot()

    # Click on the Sign In button to submit the info
    $browser.button(:value => /Sign in/).click

    # And notify the user that it was clicked
    puts "Aaaaand I clicked Sign In."
    puts $newline

end

def HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)
    
    $head_of_customer_service_name << name_of_rep
    $head_of_customer_service_title << title_of_rep
    $head_of_customer_service_linkedin << linkedin_url_of_rep
    puts "The head of customer service is #{$head_of_customer_service_name}"

end

### END FUNCTION SECTION ###
Dir.glob("/**/LinkedIn Scraper \(#{version_number}\).rb") do |file|
    $home_path = (File.dirname(file))
    puts $home_path
end

# Make screenshots folder if doesn't already exist
unless Dir.exist? "#{$home_path}/screenshots"
    FileUtils.mkpath "#{$home_path}/screenshots"
end

# Make leads folder if doesn't already exist
unless Dir.exist? "#{$home_path}/leads/#{year}/#{month}/"
    FileUtils.mkpath "#{$home_path}/leads/#{year}/#{month}/"
end

#############
### START ###
#############
puts "############# #{$newline}" +
     "### START ### #{$newline}" +
     "############# #{$newline}"

puts "Loading #{initialPage}#{$newline}"

# Webpage we want to start at
$browser.goto initialPage

# Get the title of page
puts "You are now on #{$browser.title}"
puts $newline

# puts "If you want to start on a particular page in the search, please input it now."
# $pagination_page_number = STDIN.gets.chomp.to_i
# puts $newline

### Environment Variables
$emailCredentials = [ENV["USERNAME"], ENV["PASSWORD"]]

#########################
### EXPERT LOGIN PAGE ###
#########################
puts "########################### #{$newline}" +
     "### LINKEDIN LOGIN PAGE ### #{$newline}" +
     "########################### #{$newline}"

# URL of Page
CurrentPage()

# WAIT for PAGE to LOAD
sleep(3)

# Log In via Email
EmailLogIn()

# WAIT on DASHBOARD to LOAD
begin
    
    # WAIT 20 SECONDS FOR DASHBOARD TO LOAD
    $browser.window(:title => "Welcome! | LinkedIn").wait_until_present(timeout: 20)

    puts "Logging in to LinkedIn! Woo!"
    puts $newline
    # Screenshot()

# OTHERWISE
rescue
    puts "Uh oh. We didn't log in to LinkedIn."
    # Screenshot()
    exit
    Close()
end

##############
### SEARCH ###
##############
puts "############## #{$newline}" +
     "### SEARCH ### #{$newline}" +
     "############## #{$newline}"

$browser.goto $searchPage

# URL of Current Page
CurrentPage()
# Screenshot()

# Wait for page to load
sleep(3)

puts "#{$home_path}/leads/#{year}/#{month}/(#{month}.#{day}.#{year.to_s[2..3]}) leads.csv"
csv_path = "#{$home_path}/leads/#{year}/#{month}/(#{month}.#{day}.#{year.to_s[2..3]}) leads.csv"

CSV.open(csv_path, "wb") do |csv|

    csv << [
                "Company Name",
                "Website",
                "Location",
                "Address",
                "# of Employees",
                "Head of Customer Service Name",
                "Head of Customer Service Title",
                "Head of Customer Service LinkedIn",
                "Type of Company"
            ]

end

CSV.open(csv_path, "a") do |csv|

    unless $pagination_page_number == 0
        $browser.ul(:class_name => 'pagination').li(:class_name => /link/, :text => "#{$pagination_page_number}").click
        puts "Clicking on page #{$pagination_page_number}."
        $pagination_page_number += 1
        sleep(3)
        $searchPage = $browser.url
    end

    until ($browser.li(:class_name => /next/i, :text => /next/i).exists? == false) do
    # until ($count == 41) do

        puts "The index is #{$count}."
        puts "The pagination_page_number is #{$pagination_page_number}"

        if $count > 0 && $pagination_page_number == 0
            $browser.ul(:class_name => 'pagination').li(:class_name => /link/, :text => "#{($count + 1)}").click
            puts "Clicking on page #{$count + 1}"
            $count += 1
            sleep(2)
            $searchPage = $browser.url
        elsif $count > 0 && $pagination_page_number > 0
            $browser.ul(:class_name => 'pagination').li(:class_name => /link/, :text => "#{$pagination_page_number}").click
            puts "Clicking on page #{$pagination_page_number}."
            $pagination_page_number += 1
            sleep(2)
            $searchPage = $browser.url
        end

        $browser.divs(:class_name => 'bd').each do |d|

            company_name = d.h3.a.text
            puts company_name
            type_of_company = d.div(:class_name => 'description').text
            puts type_of_company
            location = d.dl(:class_name => 'demographic').dds[0].text
            puts location
            number_of_employees = d.dl(:class_name => 'demographic').dds[1].text 
            number_of_employees = number_of_employees.match(/(\d{,3}-\d{,3})/)
            puts number_of_employees

            # Go to Company LinkedIn Profile
            number_of_retries = 0
            begin
                d.h3.a.click
            rescue Net::ReadTimeout => e
                $browser.refresh
                number_of_retries += 1
                retry unless number_of_retries > 1
                puts "Got an #{e.message} error, so just skipping this company."
                next
            end

            sleep(3)

            puts "Getting the website for #{company_name}."

            # Click Show Details bar if it exists
            begin
                unless $browser.button(:class_name => "view-toggle-bar-offscreen").exists?
                    $browser.button(:class_name => "view-more-bar").click
                end
            rescue
                puts "LinkedIn's old type of button isn't there."
                if $browser.button(:text => /Show details/).exists?
                    puts "Trying to click LinkedIn's new type of 'Show Details' button..."
                    $browser.button(:text => /Show details/).click
                    puts "I clicked on LinkedIn's new type of 'Show Details' button!"
                else
                    puts "Neither type of button is there."
                end
            end

            # Website
            if $browser.li(:class_name => 'website').p.exists?
                puts "Looking for the website..."
                website = $browser.li(:class_name => 'website').p.text
                puts "The website for #{company_name} is #{website}"
            elsif $browser.dd(:class_name => /org-about-company-module__company-page-url/).exists?
                puts "Looking for the new LinkedIn website container..."
                puts "It's #{$browser.dd(:class_name => /org-about-company-module__company-page-url/).exists?} that the new LinkedIn website container exists."
                website = $browser.dd(:class_name => /org-about-company-module__company-page-url/).text
                puts "Found the new LinkedIn website container!"
            else 
                puts "The company doesn't seem to have a website."
            end

            # Address
            if $browser.li(:class_name => /vcard hq/).p.exists?
                address = $browser.li(:class_name => /vcard hq/).p.text
                puts "#{company_name}'s address is is #{address}"
            elsif $browser.dd(:class_name => /org-about-company-module__headquarter/).exists?
                puts "Looking for the new LinkedIn address container..."
                puts "It's #{$browser.dd(:class_name => /org-about-company-module__headquarter/).exist?} that the headquarters address exists."
                address = $browser.dd(:class_name => /org-about-company-module__headquarter/).text
                puts "Found the new LinkedIn headquarters address container."
            else
                puts "The company doesn't seem to have an address."
            end

            # FIND HEAD OF CUSTOMER SERVICE
            
            # Navigate to list of employees on LinkedIn
            if $browser.element(:class_name => /more/, :text => /See all/).exists?
                puts "Trying to find the old-school 'See All Employees' button."
                $browser.element(:class_name => /more/, :text => /See all/).click
                puts "Used the old-school 'See All Employees' button to view #{company_name}'s employees on LinkedIn."
            elsif $browser.span(:class_name => /org-company-employees-snackbar__see-all-employees-link/).a.exists?
                puts "Trying to find the new 'See All Employees' button."
                $browser.goto $browser.span(:class_name => /org-company-employees-snackbar__see-all-employees-link/).a.href
                puts "Clicked the new LinkedIn employees element."
            else
                puts "No employees on LinkedIn. How unfortunate... Anyway, moving to the next company.#{$newline}"
                $browser.goto $searchPage
                next
            end

            if $browser.ul(:class_name => /pagination/).exist?
                
                number_of_pages = ($browser.ul(:class_name => /pagination/).lis.length - 1)
                upper_limit = (number_of_pages > 5) ? "5" : "#{number_of_pages}"
                puts "There are #{number_of_pages} pages."
                on_page = 1

                while $browser.ul(:class_name => /pagination/).exist? && ($browser.ul(:class_name => /pagination/).li(:text => upper_limit).class_name == "link")

                    # puts $browser.ul(:class_name => /pagination/).li(:text => upper_limit).class_name
                    puts "Page #{on_page}/#{number_of_pages}."

                    unless on_page == 1
                        begin
                            puts "It is #{$browser.li(:class_name => /next/i, :text => /Next/).exist?} that the Next button exists."
                            $browser.li(:class_name => /next/i, :text => /Next/).click
                        rescue
                            puts "Trying to click the actual page number instead..."
                            begin
                                $browser.ul(:class_name => /pagination/).li(:text => "#{on_page}").click
                                puts "It is #{$browser.ul(:class_name => /pagination/).li(:text => "#{on_page}").exist?} that the #{on_page} button exists."
                            rescue
                                puts "Couldn't find the page number. Moving on..."
                                on_page += 1
                                next
                            end
                        end
                    end

                    $browser.divs(:class_name => 'bd').each do |bd|
                        begin
                            unless (bd.dl(:class_name => 'snippet').exists? == false)

                                name_of_rep = bd.h3.a.text
                                title_of_rep = bd.p(:class_name => 'title').text[0..50] if bd.p(:class_name => 'title').exist?
                                linkedin_url_of_rep = bd.h3.a.href

                                if bd.p(:class_name => 'title').text.match(/((customer|client|consumer)\s(success|service|experience|happiness|care))/i)
                                
                                    HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                                elsif bd.p(:class_name => 'title').text.match(/(Chief\sExecutive\sOfficer)|(President)|(Chief\sOperations\sOfficer)|(Chief Technology Officer)|(Chief (Marketing|Creative) Officer)|((VP|Vice Presdient|Director) of (Sales|Business Development))/i)
                                
                                    HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                                elsif bd.p(:class_name => 'title').text.match(/CEO|COO|CTO|CMO|Founder/)

                                    HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                                end # INNER BD LOOP IF STATEMENT
                            end # IF BD.DL EXISTS
                        rescue
                            puts "The code likely couldn't find a particular snippet."
                        end
                    end # INNER BD LOOP
                    
                    on_page += 1
                end # INNER PAGINATION WHILE LOOP

            else

                number_of_pages = 1
                puts "There's only one page."

                $browser.divs(:class_name => 'bd').each do |bd|
                    begin
                        unless (bd.dl(:class_name => 'snippet').exists? == false)

                            name_of_rep = bd.h3.a.text
                            title_of_rep = bd.p(:class_name => 'title').text[0..50] if bd.p(:class_name => 'title').exist?
                            linkedin_url_of_rep = bd.h3.a.href

                            if bd.p(:class_name => 'title').text.match(/((customer|client|consumer)\s(success|service|experience|happiness|care))/i)
                                
                                HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                            elsif bd.p(:class_name => 'title').text.match(/(Chief\sExecutive\sOfficer)|(President)|(Chief\sOperations\sOfficer)|(Chief Technology Officer)|(Chief (Marketing|Creative) Officer)|((VP|Vice Presdient|Director) of (Sales|Business Development))/i)
                            
                                HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                            elsif bd.p(:class_name => 'title').text.match(/CEO|COO|CTO|CMO|Founder/)

                                HeadOfCustomerService(name_of_rep, title_of_rep, linkedin_url_of_rep)

                            end # INNER BD LOOP IF STATEMENT
                        end # IF BD.DL EXISTS
                    rescue
                        puts "The code likely couldn't find a particular snippet."
                    end
                end # INNER BD LOOP
                
            end # IF STATEMENT

            # Add all info to CSV
            if $head_of_customer_service_name.length > 1

                $head_of_customer_service_name.each_with_index do |hocs, index|

                    csv << [
                        company_name,
                        website,
                        location,
                        address,
                        number_of_employees,
                        $head_of_customer_service_name[index],
                        $head_of_customer_service_title[index],
                        $head_of_customer_service_linkedin[index],
                        type_of_company
                    ]

                end
            else

                csv << [
                        company_name,
                        website,
                        location,
                        address,
                        number_of_employees,
                        $head_of_customer_service_name[0],
                        $head_of_customer_service_title[0],
                        $head_of_customer_service_linkedin[0],
                        type_of_company
                    ]
            end
            
            # Go back to the search page
            begin
                $browser.goto $searchPage
            rescue
                $browser.refresh
                $browser.goto $searchPage
            end
            # puts $browser.url == $searchPage
            puts "\n"
            # Reset all the values
            company_name = ''
            website = ''
            location = ''
            address = ''
            number_of_employees = ''
            $head_of_customer_service_name = []  
            $head_of_customer_service_title = [] 
            $head_of_customer_service_linkedin = []  
            type_of_company = ''
            sleep(3)
            
        end # OUTER BD LOOP

        # Increment the count after the first page so that the click logic on top will execute for all subsequent pages
        if $count == 0
            $count += 1
        end

    end # OUTER PAGINATION LOOP
end # CSV

Close()

# <a class="result-image" href="/company/2934787?trk=vsrp_companies_res_photo&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A2934787%2CVSRPcmpt%3Aprimary">
#     <img class="entity-img" width="100" height="100" src="https://media.licdn.com/mpr/mpr/shrink_100_100/p/6/000/1fd/1e7/11c88bc.png">
# </a>
# <div class="bd">
#     <h3>
#         <a class="title main-headline" href="/company/2934787?trk=vsrp_companies_res_name&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A2934787%2CVSRPcmpt%3Aprimary">Strategic Search Partners</a>
#         <span class="badges"></span>
#     </h3>
#     <div class="description">Consumer Goods</div>
#     <dl class="demographic">
#         <dt>Location</dt>
#         <dd class="separator">
#             <bdi dir="ltr">Dallas/Fort Worth Area</bdi>
#         </dd>
#         <dt>Company Size</dt>
#         <dd>1-10 employees</dd>
#     </dl>
# </div>

# <a class="result-image" href="/company/3185884?trk=vsrp_companies_res_photo&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary"><img class="entity-img" width="100" height="100" src="https://media.licdn.com/mpr/mpr/shrink_100_100/AAEAAQAAAAAAAAKZAAAAJDFhZmMyYTIxLTJiMWMtNDM5Ny04MmFhLTRkYjcwYWY0NTI5NA.png"></a><div class="bd"><h3><a class="title main-headline" href="/company/3185884?trk=vsrp_companies_res_name&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary">Poo~Pourri</a><span class="badges"></span></h3><div class="description">Consumer Goods</div><dl class="demographic"><dt>Location</dt><dd class="separator"><bdi dir="ltr">Dallas/Fort Worth Area</bdi></dd><dt>Company Size</dt><dd>11-50 employees</dd></dl><div class="related-wrapper collapsed"><ul class="related-line"><li class="similar"><a href="/vsearch/c?rsid=2154172441482889680599&amp;pivotType=sim&amp;pid=3185884&amp;trk=vsrp_companies_res_sim&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary">Similar</a></li></ul><div class="expansion-container"></div></div><div class="srp-actions blue-button"><a class="primary-action-button label" href="/company/follow/submit?id=3185884&amp;fl=start&amp;sp=srch&amp;csrfToken=ajax%3A5453894620188680550&amp;trk=vsrp_companies_res_pri_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary" data-li-anti-href="/company/follow/submit?id=3185884&amp;fl=stop&amp;sp=srch&amp;csrfToken=ajax%3A5453894620188680550&amp;trk=vsrp_companies_res_sec_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary" data-li-anti-text="Unfollow" data-li-badge-text="[Following]" data-li-result-interaction="follow-company">Follow</a><div class="secondary-actions-trigger"><button role="button" class="trigger"><span>Secondary Actions</span></button><ul class="menu"><li><a href="/company/3185884?trk=vsrp_companies_res_sec_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary" data-li-anti-href="/company/3185884?trk=vsrp_companies_res_pri_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary">View</a></li></ul></div></div></div>
# <a href="/vsearch/c?rsid=2154172441482889680599&amp;pivotType=sim&amp;pid=3185884&amp;trk=vsrp_companies_res_sim&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary">Similar</a>
# <a href="/company/3185884?trk=vsrp_companies_res_sec_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary" data-li-anti-href="/company/3185884?trk=vsrp_companies_res_pri_act&amp;trkInfo=VSRPsearchId%3A2154172441482889680599%2CVSRPtargetId%3A3185884%2CVSRPcmpt%3Aprimary">View</a>